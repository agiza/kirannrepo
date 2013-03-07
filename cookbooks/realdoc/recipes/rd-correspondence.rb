#
# Cookbook Name:: realdoc
# Recipe:: realdoc-correspondence
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "rd-correspondence"
app_version = node[:rdcorr_version]

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty? || app_version = "0.0.0-1"
    new_version = search(:node, "recipes:realdoc\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:rdcorr_version]
      node.set[:rdcorr_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

# trigger node attribute creation.
include_recipe "realdoc::default"
amqphost = node[:amqphost]
amqpport = node[:amqpport]
rdochost = node[:rdochost]
rdocport = node[:rdocport]
elasticHost = node[:elasticHost]

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall')
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

mongoHost = "127.0.0.1"

directory "/opt/tomcat/correspondence" do
  owner "tomcat"
  group "tomcat"
end

directory "/opt/tomcat/correspondence/input" do
  owner "tomcat"
  group "tomcat"
end

# Integration components
webHost = data_bag_item("infrastructure", "apache")
rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split(" ").first.split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
mysql = Chef::DataBag.load("infrastructure")
if mysql["mysqldb#{node.chef_environment}"]
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
else
  mysqldb = data_bag_item("infrastructure", "mysqldb")
end
#ftpserver = data_bag_item("integration", "realdoc")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :mongo_host => "#{mongoHost}",
    :elastic_host => "#{elasticHost}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rdrabbit[0]}",
    :amqppass => "#{rdrabbit[1]}",
    :rdochost => "#{rdochost}:#{rdocport}",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver,
    :ldapserver => ldapserver,
    #:ftpserver => ftpserver,
    :mysqldb => mysqldb["realdoc"]
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "realdoc.xml.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  variables(:mysqldb => mysqldb["realdoc"])
  notifies :restart, resources(:service => "altitomcat")
end

include_recipe "realdoc::correspondence-mount"

