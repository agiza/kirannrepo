#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"

package "mongo-10gen" do
  action :upgrade
end

package "mongo-10gen-server" do
  action :upgrade
end

directory "/var/run/mongo" do
  owner "mongod"
  group "mongod"
end

