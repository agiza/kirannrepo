#
# Cookbook Name:: dns
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
yum_package "bind" do
  action :upgrade
end

yum_package "bind-utils" do
  action :upgrade
end

service "named" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/named.conf" do
  source "named.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/rndc.key" do
  source "/etc/rndc.key.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

