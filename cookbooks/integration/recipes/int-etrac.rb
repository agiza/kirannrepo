#
# Cookbook Name:: integration
# Recipe:: int-etrac
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-etrac"
app_version = node[:intetrac_version]

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:integration\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:intetrac_version]
      node.set[:intetrac_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end


include_recipe "altisource::altitomcat"
include_recipe "integration::default"
amqphost = node[:amqphost]
amqpport = node[:amqpport]

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

amqpcred = data_bag_item("rabbitmq", "l1")
amqpcred = amqpcred['user'].split("|")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{amqpcred[0]}",
    :amqppass => "#{amqpcred[1]}"
  )
  notifies :restart, resources(:service => "altitomcat")
end

directory "/opt/tomcat/EtracRegistry" do
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
end

