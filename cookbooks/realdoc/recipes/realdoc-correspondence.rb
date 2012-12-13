#
# Cookbook Name:: realdoc
# Recipe:: realdoc-correspondence
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realdoc-correspondence"
app_version = node[:rdcorr_version]

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

service "realdoc-correspondence" do
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
  notifies :restart, resources(:service => "realdoc-correspondence")
end

if node.attribute?('mongomasterproxy')
  mongoHost = node[:mongomasterproxy]
else
  mongoHost = {}
  search(:node, "role:mongodb-master") do |n|
    mongoHost[n.ipaddress] = {}
  end
mongoHost = mongoHost.first
end
if node.attribute?('elasticsearchproxy')
  elasticHost = node[:elasticsearchproxy]
else
  elasticHost = {}
  search(:node, "role:elasticsearch AND chef_environment:#{node.chef_environment}") do |n|
    elasticHost[n.ipaddress] = {}
  end
end

# Integration components
webHost = data_bag_item("infrastructure", "apache")
rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
template "/opt/#{app_name}/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group  'javaapp'
  owner  'javaapp'
  mode   '0644'
  notifies :restart, resources(:service => "#{app_name}")
  variables(
    :mongo_host => "#{mongoHost}",
    :elastic_host => "#{elasticHost}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rdrabbit[0]}",
    :amqppass => "#{rdrabbit[1]}",
    :rdochost => "#{rdochost}:#{rdocport}",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver,
    :ldapserver => ldapserver,
    :mysqldb => mysqldb["realdoc"]
  )
end

