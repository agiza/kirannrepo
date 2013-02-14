#
# Cookbook Name:: hubzu
# Recipe:: hubzu
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "hubzu"
app_version = node[:hubzu_version]

include_recipe "altisource::altitomcat"

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:hubzu\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:hubzu_version]
      node.set[:hubzu_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

if node.attribute?('hzproxy')
  hzhost = node[:hzproxy].split(":")[0]
  hzport = node[:hzproxy].split(":")[1]
else
  hzhost = search(:node, "recipes:hubzu\\:\\:hubzu OR role:hubzu AND chef_environment:#{node.chef_environment}")
  if hzhost.nil? || hzhost.empty?
    Chef::Log.warn("No services found.") && hzhost = "No servers found."
  else
    hzhost = hzhost.first
    hzhost = hzhost["ipaddress"]
    hzport = "8080"
  end
end

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

webHost = data_bag_item("infrastructure", "apache")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
template "/opt/tomcat/conf/hubzu.properties" do
  source "hubzu.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables( 
    :webHostname => webHost["hz#{node.chef_environment}"],
    :mailserver => mailserver,
    :melissadata => melissadata['melissadata'],
    :ldapserver => ldapserver,
    :hzserver => "#{hzhost}:#{hzport}"
  )
end

mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb["#{app_name}"])
  notifies :restart, resources(:service => "altitomcat")
end

