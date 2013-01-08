#
# Cookbook Name:: mongodb
# Recipe:: shard
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "mongodb::default"
include_recipe "altisource::altirepo"

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

configserver = []
configs = search(:node, "role:mongod-config")
configs.each do |ipaddress|
  configserver << ipaddress[:ipaddress]
end
configserver = configserver.collect { |entry| "#{entry}:27001"}.join(",")
template "/etc/mongod.conf" do
  source "mongod-shard.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  variables(:mongodbconfig => configserver)
  notifies :reload, resources(:service => "mongod")
end


service "mongod" do
  action [:enable, :start]
end

