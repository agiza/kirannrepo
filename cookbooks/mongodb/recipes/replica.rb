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

directory "/data/db" do
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

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true, :disable => true
  action :nothing
end

template "/etc/#{app_name}.conf" do
  source "mongod.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  variables(
    :app_name => "#{app_name}"
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

if node.run_list("recipes[mongodb::mongod]")?
  Chef::Log.info("This is also a mongodb-primary server.")
else
  service "mongod" do
    action [:disable, :stop]
  end
end

service "#{app_name}" do
  action [:enable, :start]
end

