#
# Cookbook Name:: mongodb
# Recipe:: arbiter
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

service "mongod-arbiter" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

template "/etc/mongod-arbiter.conf" do
  source "mongod-arbiter.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod-arbiter")
end

template "/etc/init.d/mongod-arbiter" do
  source "mongod-arbiter-init.erb"
  group  "root"
  owner  "root"
  mode   "0755"
  notifies :reload, resource(:service => "mongod-arbiter")
end

service "mongod-arbiter" do
  action [:enable, :start]
end

