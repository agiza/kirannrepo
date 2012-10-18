#
# Cookbook Name:: l1
# Recipe:: l1-rp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "l1-rp"
app_version = node[:l1rp_version]

include_recipe "altisource::altitomcat"
if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy]
else
  rdochost = {}
  search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
    rdochost[n.ipaddress] = {}
  end
  rdochost = rdochost.first
end
if node.attribute?('l1cenproxy')
  l1cenhost = node[:l1cenproxy]
else
  l1cenhost = {}
  search(:node, "role:l1-cen AND chef_environment:#{node.chef_environment}") do |n|
    l1cenhost[n.ipaddress] = {}
  end
  l1cenhost = l1cenhost.first
end
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
l1rabbit = data_bag_item("rabbitmq", "realtrans")
l1rabbit = l1rabbit['user'].split("|")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["rt#{node.chef_environment}"],
    :realdoc_hostname => "#{rdochost}:8080",
    :l1_cen_host => "#{l1cenhost}:8080",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{l1rabbit[0]}",
    :amqppass => "#{l1rabbit[1]}"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

