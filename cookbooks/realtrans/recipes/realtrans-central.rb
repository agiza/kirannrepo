#
# Cookbook Name:: realtrans
# Recipe:: realtrans-central
#

#include_recipe "java"
app_name = "realtrans-central"
app_version = node[:realtranscentral_version]

# Include tomcat recipe to get tomcat installed
include_recipe "altisource::altitomcat"

# This looks for realdoc proxy attribute and allows override of realdoc server or finds the first server itself
if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy]
else
  rdochost = {}
  search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
    rdochost[n.ipaddress] = {}
  end
  rdochost = rdochost.first
end
# This looks for rt central proxy attribute or finds the first server itself.
if node.attribute?('rtcenproxy')
  rtcenhost = node[:rtcenproxy]
else
  rtcenhost = {}
  search(:node, "role:realtrans-cen AND chef_environment:#{node.chef_environment}") do |n|
    rtcenhost[n.ipaddress] = {}
  end
  rtcenhost = rtcenhost.first
end
# This looks for rt vendor proxy attribute or finds the first server itself.
if node.attribute?('rtvenproxy')
  rtvenhost = node[:rtvenproxy]
else
  rtvenhost = {}
  search(:node, "role:realtrans-ven AND chef_environment:#{node.chef_environment}") do |n|
    rtvenhost[n.ipaddress] = {}
  end
  rvcenhost = rtvenhost.first
end
# This looks for rabbitmq proxy attribute or finds the first server itself.
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

# Install the application package.
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
rtrabbit = data_bag_item("rabbitmq", "realtrans")
rtrabbit = rtrabbit['user'].split("|")
melissadata = data_bag_item("integration", "melissadata")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :webHostname => webHost["rt#{node.chef_environment}"],
    :rt_ven_host => "#{rtvenhost}:8080",
    :rt_cen_host => "#{rtcenhost}:8080",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rtrabbit[0]}",
    :amqppass => "#{rtrabbit[1]}",
    :realdoc_hostname => "#{rdochost}:8080",
    :melissadata => melissadata['melissadata']
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

