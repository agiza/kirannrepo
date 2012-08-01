#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altirepo"

service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

package "mysql-server-5.5" do
  action :upgrade
  notifies :restart, resources(:service => "mysql")
end

