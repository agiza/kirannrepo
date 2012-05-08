#
# Cookbook Name:: mongodb
# Recipe:: default
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

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :enable
  action :start
end

template "/etc/mongod.conf" do
  source "mongod.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod")
end

