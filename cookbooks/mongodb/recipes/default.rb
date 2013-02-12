#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true, :disable => true
  action :nothing
end

package "mongo-10gen" do
  action :upgrade
end

package "mongo-10gen-server" do
  action :upgrade
  notifies :stop, resources(:service => "mongod")
  notifies :disable, resources(:service => "mongod")
end

directory "/var/run/mongo" do
  owner "mongod"
  group "mongod"
end

