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

directory "/data/db" do
  owner "mongod"
  group "mongod"
end

directory "/etc/mongo" do
  owner "mongod"
  group "mongod"
end

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

execute "mongo-seed" do
  command "/etc/mongo/mongo-seed.sh" 
  action :nothing
end

template "/etc/mongod.conf" do
  source "mongod.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod")
end

mongodbnames = data_bag_item("mongodb", "names")
template "/etc/mongo/mongo-seed.sh" do
  source "mongo-seed.sh.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0755"
  variables( :mongodb_names => mongodbnames['dbnames'])
end

template "/etc/mongo/seedData.js" do
  source "seedData.js"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  notifies :run, execute[mongo-seed]
end

template "/etc/mongo/addrData.addIndexes.js" do
  source "addIndexes.js"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  notifies :run, execute[mongod-seed]
end


service "mongod" do
  action [:enable, :start]
end

