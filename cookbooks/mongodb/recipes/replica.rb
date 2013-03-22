#
# Cookbook Name:: mongodb
# Recipe:: replica
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "mongod-replica"

include_recipe "altisource::volume"
volume_mount "volume_replica" do
  volumes "sdb|mongod|mongod|defaults"
end

include_recipe "mongodb::default"
iptables_rule "port_mongod-replica"

%w{/data /data/db /data/db/replica}.each do |dir|
  directory "#{dir}" do
    owner "mongod"
    group "mongod"
  end
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

service "#{app_name}" do
  action [:enable, :start]
end

