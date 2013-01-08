#
# Cookbook Name:: mongodb
# Recipe:: replica
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "mongodb::default"
include_recipe "altisource::altirepo"

directory "/data" do
  owner "mongod"
  group "mongod"
end

directory "/data/db" do
  owner "mongod"
  group "mongod"
end

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

template "/etc/mongod.conf" do
  source "mongod-replica.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod")
end

service "mongod" do
  action [:enable, :start]
end

