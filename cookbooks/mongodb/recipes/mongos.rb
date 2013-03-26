#
# Cookbook Name:: mongodb
# Recipe:: mongos
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "mongos"
include_recipe "mongodb::default"

iptables_rule "port_mongos"

service "#{app_name}" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action [:disable, :stop]
end

# Checks for stress/performance environment attribute as this may be a separate environment.
if node.attribute?('performance')
  environment = node[:chef_environment]
else
  environment = "shared"
end

# Create an empty array for config server nodes.
configserver = []
configs = []
%w{config mongodb-config}.each do |app|
  search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environment}").each do |config|
    configs << config
  end
end
if configs.nil? || configs.empty?
  Chef::Log.fatal("No MongoDB Config servers found in search, unable to route requests.")
else
  configs[0..3].each do |config|
    configserver << config["ipaddress"]
  end
  configserver = configserver.sort.uniq
  configserver = configserver.collect { |entry| "#{entry}:27047"}.join(",")
  template "/etc/#{app_name}.conf" do
    source "mongod.conf.erb"
    group "root"
    owner "root"
    mode "0644"
    variables(
      :mongodbconfig => configserver,
      :app_name => "#{app_name}"
      )
    notifies :reload, resources(:service => "#{app_name}")
  end
  
  template "/etc/init.d/#{app_name}" do
    source "mongos-init.erb"
    group  "root"
    owner  "root"
    mode   "0755"
    variables(:app_name => "#{app_name}")
    notifies :reload, resources(:service => "#{app_name}")
  end
  
  template "/etc/logrotate.d/mongos" do
    source "mongos-logrotate.erb"
    owner  "root"
    group  "root"
    mode   "0644"
  end
end

directory "/var/run/mongo" do
  owner "mongod"
  group "mongod"
  action :create
end

service "#{app_name}" do
  action [:enable, :start]
end

