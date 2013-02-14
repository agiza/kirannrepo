#
# Cookbook Name:: integration
# Recipe:: int-corelogic
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-corelogic"
app_version = node[:intcorelogic_version]

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:integration\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:intcorelogic_version]
      node.set[:intcorelogic_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end


include_recipe "altisource::altitomcat"
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No services returned from search.") && amqphost = "No servers found."
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
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

amqpcred = data_bag_item("rabbitmq", "l1")
amqpcred = amqpcred['user'].split("|")
# Find environment specific data bag settings if they exist, if not roll back to simple data bag.
corelogicenv = data_bag_item("integration", "corelogic#{node.chef_environment}")
corelogicraw = data_bag_item("integration", "corelogic")
if corelogicenv.nil? || corelogicenv.empty?
  corelogic = corelogicraw
else
  corelogic = corelogicenv
end
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
    :corepass => "#{corelogic['pass']}",
    :coreuser => "#{corelogic['user']}",
    :coreurl => "#{corelogic['neworderurl']}",
    :coretoken => "#{corelogic['authtoken']}"
  )
  notifies :restart, resources(:service => "altitomcat")
end

