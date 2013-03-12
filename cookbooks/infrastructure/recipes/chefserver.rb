#
# Cookbook Name:: infrastructure
# Recipe:: chefserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::chefclient"

execute "chef-reconfigure" do
  command "chef-server-ctl reconfigure"
  action :nothing
end

package "chef-server" do
  action :upgrade
  notifies :run, resources(:execute => "chef-reconfigure")
end

service "chef-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/init.d/chef-server" do
  source "chef-server.init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "chef-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

