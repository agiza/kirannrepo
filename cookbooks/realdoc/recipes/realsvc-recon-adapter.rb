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
  amqphost = node[:amqpproxy]
  amqpport = node[:amqpport]
else
  amqphost = {}
  search(:node, "role:rabbitserver") do |n|
    amqphost[n.hostname] = {}
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
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}"
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

