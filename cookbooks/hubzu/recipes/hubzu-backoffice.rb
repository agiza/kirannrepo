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

if node.attribute?('hzproxy')
  hzhost = node[:hzproxy].split(":")[0]
  hzport = node[:hzproxy].split(":")[1]
else
  hzhost = {}
  search(:node, "role:hubzu AND chef_environment:#{node.chef_environment}") do |n|
    hzhost[n.ipaddress] = {}
  end
  hzhost = hzhost.first
  hzport = "8080"
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
mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
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
    :mysqldb => mysqldb["#{app_name}"]
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb["#{app_name}"])
  notifies :restart, resources(:service => "altitomcat")
end

