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
if node.attribute?('avacenproxy')
  avacenhost = node[:avacenproxy].split(":")[0]
  avacenport = node[:avacenproxy].split(":")[1]
else
  avacenhost = {}
  search(:node, "role:ava-cen AND chef_environment:#{node.chef_environment}") do |n|
    avacenhost[n.ipaddress] = {}
  end
  avacenhost = avacenhost.first
  avacenport = "8080"
end
if node.attribute?('avavenproxy')
  avavenhost = node[:avavenproxy].split(":")[0]
  avavenport = node[:avavenproxy].split(":")[1]
else
  avavenhost = {}
  search(:node, "role:ava-ven AND chef_environment:#{node.chef_environment}") do |n|
    avavenhost[n.ipaddress] = {}
  end
  avavenhost = avavenhost.first
  avavenport = "8080"
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
avarabbit = data_bag_item("rabbitmq", "realtrans")
avarabbit = avarabbit['user'].split("|")
melissadata = data_bag_item("integration", "melissadata")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["ava#{node.chef_environment}"],
    :realdoc_hostname => "#{rdochost}:#{rdocport}",
    :ava_cen_host => "#{avacenhost}:#{avacenport}",
    :ava_ven_host => "#{avavenhost}:#{avavenport}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{avarabbit[0]}",
    :amqppass => "#{avarabbit[1]}",
    :melissadata => melissadata['melissadata']
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

