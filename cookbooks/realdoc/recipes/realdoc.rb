#
# Cookbook Name:: realdoc
# Recipe:: realdoc
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realdoc"
app_version = node[:realdoc_version]

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:realdoc\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:realdoc_version]
      node.set['realdoc_version'] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

include_recipe "altisource::altitomcat"

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

package "msttcorefonts" do
  action :upgrade
end

mongoHost = "127.0.0.1"

# Integration components
webHost = data_bag_item("infrastructure", "apache")
rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split(" ").first.split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
#ftpserver = data_bag_item("integration", "realdoc")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["rd#{node.chef_environment}"],
    :mongo_host => "#{mongoHost}",
    :elastic_host => "#{elasticHost}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rdrabbit[0]}",
    :amqppass => "#{rdrabbit[1]}",
    :rdochost => "#{rdochost}:#{rdocport}",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver,
    :ldapserver => ldapserver
    #:ftpserver => ftpserver
  )
end

mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "realdoc.xml.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  variables(:mysqldb => mysqldb["#{app_name}"])
  notifies :restart, resources(:service => "altitomcat")
end

directory "/opt/tomcat/correspondence" do
  owner "tomcat"
  group "tomcat"
end

directory "/opt/tomcat/correspondence/input" do
  owner "tomcat"
  group "tomcat"
end

#template "/opt/tomcat/conf/realdoc.key" do
#  source "realdoc.key.erb"
#  owner  "tomcat"
#  group  "tomcat"
#  mode   "0600"
#end

include_recipe "realdoc::correspondence-mount"
include_recipe "realdoc::cis-mount"

