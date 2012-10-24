#
# Cookbook Name:: realfoundation
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realfoundation"
app_version = node[:realfoundation_version]

if node.attribute?('rfproxy')
  rfhost = node[:rfproxy].split(":")[0]
  rfport = node[:rfproxy].split(":")[1]
else
  rfhost = {}
  search(:node, "role:realfoundation AND chef_environment:#{node.chef_environment}") do |n|
    rfhost[n.ipaddress] = {}
  end
  rfhost = rfhost.first
  rfport = "8080"
end

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = {}
  search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
    rdochost[n.ipaddress] = {}
  end
  rdochost = rdochost.first
  rdocport = "8080"
end
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = {}
  search(:node, "role:rabbitserver") do |n|
    amqphost[n.ipaddress] = {}
  end
  amqphost = amqphost.first
  amqpport = "5672"
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
rfrabbit = data_bag_item("rabbitmq", "realtrans")
rfrabbit = rfrabbit['user'].split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
template "/opt/tomcat/conf/realfoundation.properties" do
  source "realfoundation.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables( 
    :webHostname => webHost["rf#{node.chef_environment}"],
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rfrabbit[0]}",
    :amqppass => "#{rfrabbit[1]}",
    :realdoc_hostname => "#{rdochost}:#{rdocport}",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver
  )
end

template "/opt/tomcat/conf/Catalina/localhost/realfoundation.xml" do
  source "realfoundation.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

