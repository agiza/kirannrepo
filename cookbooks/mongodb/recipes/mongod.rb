#
# Cookbook Name:: mongodb
# Recipe:: mongod
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name="mongod"

# mount volumes first before creating directory structure.
#node.default.volumes = "sdb|mongod|mongod|defaults"
#include_recipe "altisource::volgrp"

if node.attribute?("novolume")
  Chef::Log.info("No volume mount attribute is set.")
else
  volume_mount "mongod" do
    volumes "sdb|mongod|mongod|defaults"
  end
end 

include_recipe "mongodb::default"
iptables_rule "port_mongod"

directory "/etc/mongo" do
  owner "mongod"
  group "mongod"
end

service "#{app_name}" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true
  action :nothing
end

execute "install_check" do
  user  "root"
  cwd   "/usr/local/sbin"
  command "/usr/local/sbin/mongod-setup.sh"
  action :nothing
end

template "/usr/local/sbin/mongod-setup.sh" do
  source "mongod-setup.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, resources(:execute => "install_check")
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

service "#{app_name}" do
  action [:enable, :start]
end

