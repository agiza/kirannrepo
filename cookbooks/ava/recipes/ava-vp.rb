#
# Cookbook Name:: ava
# Recipe:: ava-vp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "ava-vp"
app_version = node[:avavp_version]

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
if node.attribute?('avacenproxy')
  avacenhost = node[:avacenproxy]
else
  avacenhost = {}
  search(:node, "role:ava-cen AND chef_environment:#{node.chef_environment}") do |n|
    avacenhost[n.ipaddress] = {}
  end
  avacenhost = avacenhost.first
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
  case node.chef_environment
  when "Dev","Intdev"
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

webHost = data_bag_item("apache-server", "webhost")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["ava#{node.chef_environment}"],
    :realdoc_hostname => "#{rdochost}",
    :ava_cen_host => "#{avacenhost}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

