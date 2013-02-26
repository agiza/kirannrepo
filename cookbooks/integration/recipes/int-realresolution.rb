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

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:integration\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:intrres_version]
      node.set[:intrres_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

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

# Integration elements pulled from data bag.
amqpcred = data_bag_item("rabbitmq", "realtrans")
amqpcred = amqpcred['user'].split("|")
realsvc = data_bag_item("integration", "realservicing")
realres = data_bag_item("integration", "realresolution")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{amqpcred[0]}",
    :amqppass => "#{amqpcred[1]}",
    :realres => realres,
    :realsvc => realsvc
  )
  notifies :restart, resources(:service => "altitomcat")
end

