#
# Cookbook Name:: mongodb
# Recipe:: mongoqa
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altirepo::10gen"

package "mongo-10gen" do
  action :upgrade
end

package "mongo-10gen-server" do
  action :upgrade
end

directory "/data/db1" do
  owner "mongod"
  group "mongod"
end

template "/etc/init.d/mongod1" do
  source "mongodb1-init.erb"
  group  "root"
  owner  "root"
  mode   "0644"
end

service "mongod1" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

template "/etc/mongod1.conf" do
  source "mongod1.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod1")
end

service "mongod1" do
  action [:enable, :start]
end

