#
# Cookbook Name:: mongodb
# Recipe:: slave
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::altirepo::10gen"

package "mongo-10gen" do
  action :upgrade
end

package "mongo-10gen-server" do
  action :upgrade
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
  source "mongod.slave.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod")
end

service "mongod" do
  action [:enable, :start]
end

