#
# Cookbook Name:: infrastructure
# Recipe:: logs
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::selinux"

package "httpd" do
  action :upgrade
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action  :enable
end

template "/etc/httpd/conf.d/logs.conf" do
  source "logs.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "httpd")
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :start
end


