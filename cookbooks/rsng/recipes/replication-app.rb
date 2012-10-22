#
# Cookbook Name:: rsng
# Recipe:: replication-app
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "replication-app"
app_version = node[:repapp_version]

if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy]
  amqpport = node[:amqpport]
else
  amqphost = {}
  search(:node, "role:rabbitserver") do |n|
    amqphost[n.ipaddress] = {}
  end
  amqphost = amqphost.first
  amqpport = "5672"
end

if node.attribute?('rsngproxy')
  rsnghost = node[:rsngproxy]
else
  rsnghost = {}
  search(:node, "role:rsng AND chef_environment:#{node.chef_environment}") do |n|
    rsnghost[n.ipaddress] = {}
  end
  rsnghost = "#{rsnghost.first}:8080"
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

webHost = data_bag_item("apache-server", "webhost")
template "/opt/tomcat/conf/replication-app.properties" do
  source "replication-app.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables( 
    :webHostname => webHost["rsng#{node.chef_environment}"],
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :rsnghost => "#{rsnghost}:8080"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/replication-app.xml" do
  source "replication-app.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end
