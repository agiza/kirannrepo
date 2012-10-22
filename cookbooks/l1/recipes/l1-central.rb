#
# Cookbook Name:: l1
# Recipe:: l1-central
#

#include_recipe "java"
app_name = "l1-central"
app_version = node[:l1central_version]

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

l1rabbit = data_bag_item("rabbitmq", "realtrans")
l1rabbit = l1rabbit['user'].split("|")
melissadata = data_bag_item("infrastructure", "applications").melissadata
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :l1_cen_host => "#{l1cenhost}:8080",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{l1rabbit[0]}",
    :amqppass => "#{l1rabbit[1]}",
    :realdoc_hostname => "#{rdochost}:8080",
    :address => melissadata['address'],
    :phonecheck => melissadata['phonecheck'],
    :email => melissadata['email'],
    :geocoder => melissadata['geocoder'],
    :name => melissadata['name']
  )
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end
