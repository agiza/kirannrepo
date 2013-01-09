#
# Cookbook Name:: mongodb
# Recipe:: replica
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "mongod-replica"
include_recipe "mongodb::default"

directory "/data" do
  owner "mongod"
  group "mongod"
end

directory "/data/db/replica" do
  owner "mongod"
  group "mongod"
end

service "#{app_name}" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

mongodbmaster = []
masters = search(:node, "role:mongodb-master")
masters.each do |master|
  mongodmaster << master[:ipaddress]
end
mongodbmaster = mongodbmaster.collect { |entry| "#{entry}:27017"}.join(",")
template "/etc/#{app_name}.conf" do
  source "mongod.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  variables(
    :app_name => "#{app_name}",
    :mongodbmaster => mongodbmaster
  )
  notifies :reload, resources(:service => "#{app_name}")
end

template "/etc/init.d/#{app_name}" do
  source "mongod-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  variables(:app_name => "#{app_name}")
  notifies :reload, resources(:service => "#{app_name}")
end

service "#{app_name}" do
  action [:enable, :start]
end

