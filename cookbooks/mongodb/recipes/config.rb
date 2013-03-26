#
# Cookbook Name:: mongodb
# Recipe:: config
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "mongod-config"
include_recipe "mongodb::default"

iptables_rule "port_mongod-config"

directory "/data/db/config" do
  owner "mongod"
  group "mongod"
end

service "#{app_name}" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

template "/etc/#{app_name}.conf" do
  source "mongod.conf.erb"
  group "root"
  owner "root"
  mode "0644"
  variables(:app_name => "#{app_name}")
  notifies :reload, resources(:service => "#{app_name}")
end

template "/etc/init.d/#{app_name}" do
  source "mongod-init.erb"
  group  "root"
  owner  "root"
  mode   "0755"
  variables(:app_name => "#{app_name}")
  notifies :reload, resources(:service => "#{app_name}")
end

template "/etc/logrotate.d/mongod" do
  source "mongod-logrotate.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

service "#{app_name}" do
  action [:enable, :start]
end

