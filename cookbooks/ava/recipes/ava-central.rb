#
# Cookbook Name:: ava
# Recipe:: ava-central
#

#include_recipe "java"
app_name = "ava-central"
app_version = node[:avacentral_version]

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

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :webHostname => webHost["ava#{node.chef_environment}"],
    :ava_cen_host => "#{avacenhost}",
    :amqphost => "#{amqphost}",
    :realdoc_hostname => "#{rdochost}"
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

