#
# Cookbook Name:: mongodb
# Recipe:: shard
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "mongod-shard"
include_recipe "mongodb::default"

service "#{app_name}" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

configserver = []
configs = search(:node, "role:mongodb-config")
configs.each do |config|
  configserver << config[:ipaddress]
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

directory "/data" do
  owner "mongod"
  group "mongod"
  action :create
end

directory "/data/db" do
  owner "mongod"
  group "mongod"
  action :create
end

directory "/data/db/shard" do
  owner "mongod"
  group "mongod"
  action :create
end

service "#{app_name}" do
  action [:enable, :start]
end

