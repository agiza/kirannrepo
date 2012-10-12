#
# Cookbook Name:: integration
# Recipe:: int-realresolution
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-realresolution"
app_version = node[:intrres_version]

include_recipe "altisource::altitomcat"
if node.attribute?('ampqproxy')
  ampqhost = node[:ampqproxy]
else
  ampqhost = {}
  search(:node, "role:rabbitserver") do |n|
    ampqhost[n.hostname] = {}
  end
  ampqhost = ampqhost.first
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
  variables(:amqphost => "#{amqphost}")
  notifies :restart, resources(:service => "altitomcat")
end

