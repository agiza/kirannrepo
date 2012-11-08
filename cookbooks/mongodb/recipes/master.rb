#
# Cookbook Name:: mongodb
# Recipe:: master
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::10gen"

package "mongo-10gen" do
  action :upgrade
end

package "mongo-10gen-server" do
  action :upgrade
end

directory "/data" do
  owner  "root"
  group  "root"
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

template "/etc/mongod.conf" do
  source "mongod.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  notifies :reload, resources(:service => "mongod")
end

execute "mongod-seed" do
  command "/etc/mongo/mongod-seed.sh"
  action :nothing
end

mongodbnames = data_bag_item("infrastructure", "mongodb")
template "/etc/mongo/mongod-seed.sh" do
  source "mongod-seed.sh.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0755"
  notifies :run, resources(:execute => "mongod-seed")
  variables( :mongodb_names => mongodbnames["dbnames"] )
end

template "/etc/mongo/seedData.js" do
  source "seedData.js"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  notifies :run, resources(:execute => "mongod-seed")
end

template "/etc/mongo/addrData.addIndexes.js" do
  source "addIndexes.js"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  notifies :run, resources(:execute => "mongod-seed")
end

template "/etc/mongo/demoData.js" do
  source "demoData.js"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  notifies :run, resources(:execute => "mongod-seed")
end

service "mongod" do
  action [:enable, :start]
end

