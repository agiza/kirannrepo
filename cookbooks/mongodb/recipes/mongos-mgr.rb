#
# Cookbook Name:: mongodb
# Recipe:: mongos-mgr
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "mongos-mgr"
include_recipe "mongodb::default"

iptables_rule "port_mongod-mgr"

service "#{app_name}" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

execute "mongod-seed" do
  command "/etc/mongo/mongod-seed.sh"
  action :nothing
end

mongodbnames = data_bag_item("infrastructure", "mongodb")
template "/etc/mongo/mongod-seed.sh" do
  source "mongod-seed.sh.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0755"
  #notifies :run, resources(:execute => "mongod-seed")
  variables( :mongodb_names => mongodbnames["dbnames"] )
end

template "/etc/mongo/seedData.js" do
  source "seedData.js.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  variables(
    :seeddata => mongodbnames['seedData.js']
  )
  #notifies :run, resources(:execute => "mongod-seed")
end

template "/etc/mongo/addIndexes.js" do
  source "addIndexes.js.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  variables(
    :addindexes => mongodbnames['addIndexes.js']
  )
  #notifies :run, resources(:execute => "mongod-seed")
end

template "/etc/mongo/demoData.js" do
  source "demoData.js.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  variables(
    :demodata => mongodbnames['demoData.js']
  )
  #notifies :run, resources(:execute => "mongod-seed")
end

template "/etc/logrotate.d/mongos" do
  source "mongos-logrotate.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

configserver = []
if node.attribute?('performance')
  configs = search(:node, "recipes:mongodb\\:\\:config OR role:mongodb-config AND chef_environment:#{node.chef_environment}")
else
  configs = search(:node, "recipes:mongodb\\:\\:config OR role:mongodb-config AND chef_environment:shared")
end
if configs.nil? || configs.empty?
  Chef::Log.info("No mongodb config servers returned from search.") && configserver << "127.0.0.1"
else
  configs.each do |config|
    configserver << config["ipaddress"]
  end
end
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

directory "/var/run/mongo" do
  owner "mongod"
  group "mongod"
  action :create
end

service "#{app_name}" do
  action [:enable, :start]
end

