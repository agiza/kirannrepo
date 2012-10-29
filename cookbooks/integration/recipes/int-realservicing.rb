#
# Cookbook Name:: integration
# Recipe:: int-realservicing
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-realservicing"
app_version = node[:intrs_version]

include_recipe "altisource::altitomcat"
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

# Integration elements.
amqpcred = data_bag_item("rabbitmq", "realtrans")
amqpcred = amqpcred['user'].split("|")
realservicing = data_bag_item("integration", "realservicing")
realsvcsim = search(:node, "run_list:recipe\[integration\:\:realsvc-sim\] AND chef_environment:#{node.chef_environment}").ipaddress
if realsvcsim.nil? || realsvcsim.empty?
  realsvcrequrl = "http://#{realsvcsim}:8080/int-realservicing-simulator/order/create/"
  realsvcresurl = "http://#{realsvcsim}:8080/int-realservicing-simulator/order/response/ack/"
else
  realsvcrequrl = realservicing['requesturl']
  realsvcresurl = realservicing['responseurl']
end
template "/opt/tomcat/conf/int-realservicing.properties" do
  source "int-realservicing.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{amqpcred[0]}",
    :amqppass => "#{amqpcred[1]}",
    :realsvc => realservicing,
    :realsvcrequrl => realsvcrequrl,
    :realsvcresurl => realsvcresurl
  )
  notifies :restart, resources(:service => "altitomcat")
end

