#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altirepo::aegisco"

package "mongo-10gen-server" do
  version "2.0.4-mongodb_1"
  action :install
end

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :enable, :start
end

template "/etc/mongod.conf" do
  source "mongod.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod")
end

