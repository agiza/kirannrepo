#
# Cookbook Name:: mongodb
# Recipe:: mongod
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name="mongod"
include_recipe "mongodb::default"

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

service "#{app_name}" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

template "/etc/#{app_name}.conf" do
  source "#{app_name}.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  variables(:app_name => "#{app_name}")
  notifies :reload, resources(:service => "#{app_name}")
end

template "/etc/init.d/#{app_name}" do
  source "#{app_name}-init.erb"
  group "root"
  owner "root"
  mode "0755"
  variables(:app_name => "#{app_name}")
  notifies :reload, resources(:service => "#{app_name}")
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
  #notifies :run, resources(:execute => "mongod-seed")
  variables( :mongodb_names => mongodbnames["dbnames"] )
end

template "/etc/mongo/seedData.js" do
  source "seedData.js.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  variables(
    :seeddata => mongodbnames['seedData.js']
  )
  #notifies :run, resources(:execute => "mongod-seed")
end

template "/etc/mongo/addIndexes.js" do
  source "addIndexes.js.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  variables(
    :addindexes => mongodbnames['addIndexes.js']
  )
  #notifies :run, resources(:execute => "mongod-seed")
end

template "/etc/mongo/demoData.js" do
  source "demoData.js.erb"
  owner  "mongod"
  group  "mongod"
  mode   "0644"
  variables(
    :demodata => mongodbnames['demoData.js']
  )
  #notifies :run, resources(:execute => "mongod-seed")
end

service "#{app_name}" do
  action [:enable, :start]
end

