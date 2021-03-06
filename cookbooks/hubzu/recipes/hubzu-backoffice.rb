#
# Cookbook Name:: hubzu
# Recipe:: hubzu-backoffice
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "hubzu-backoffice"
app_version = node[:hubzubo_version]

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty? || app_version == "0.0.0-1"
    new_version = search(:node, "recipes:hubzu\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty? || new_version == "0.0.0-1"
      Chef::Log.info("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:hubzubo_version]
      node.set[:hubzubo_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

include_recipe "hubzu::default"
hzhost = node[:hzhost]
hzport = node[:hzport]
amqphost = node[:amqphost]
amqpport = node[:amqpport]
rdochost = node[:rdochost]
rdocport = node[:rdocport]

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed for version is still invalid default.")
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

webHost = data_bag_item("infrastructure", "apache")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
begin
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
    rescue Net::HTTPServerException
      mysqldb = data_bag_item("infrastructure", "mysqldb")
        rescue Net::HTTPServerException
          raise "Unable to find default or environment mysqldb databag."
end
hubzuamqp = data_bag_item("rabbitmq", "hubzu")
hubzucred = hubzuamqp['user'].split(" ").first.split("|")

begin
      backoffice = data_bag_item("hubzu", "backoffice#{node.chef_environment}")
        rescue Net::HTTPServerException
           raise "Unable to find hubzu-backoffice environment specifc databag."
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables( 
    :webHostname => webHost["hz#{node.chef_environment}"],
    :mailserver => mailserver,
    :melissadata => melissadata['melissadata'],
    :ldapserver => ldapserver,
    :hzserver => "#{hzhost}:#{hzport}",
    :amqphost => amqphost,
    :amqpport => amqpport,
    :amqpuser => "#{hubzucred[0]}",
    :amqppass => "#{hubzucred[1]}",
    :mysqldb => mysqldb["#{app_name}"],
    :backoffice => backoffice["backoffice"]
  )
end

template "/opt/tomcat/conf/esignature-client.properties" do
  source "esignature-client.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :backoffice => backoffice["backoffice"]
  )
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb["#{app_name}"])
  notifies :restart, resources(:service => "altitomcat")
end

