#
# Cookbook Name:: realdoc
# Recipe:: realsvc-recon-adapter
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realsvc-recon-adapter"
app_version = node[:reconadapter_version]

include_recipe "altisource::altitomcat"
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:realdoc AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.info("No services returned from search.") && amqphost = "No amqp servers found on search."
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
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

rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split(" ").first.split("|")
ftpserver = data_bag_item("integration", "realdoc")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rdrabbit[0]}",
    :amqppass => "#{rdrabbit[1]}",
    :ftpserver => ftpserver
  )
  notifies :restart, resources(:service => "altitomcat")
end

