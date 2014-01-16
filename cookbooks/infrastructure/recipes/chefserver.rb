#
# Cookbook Name:: infrastructure
# Recipe:: chefserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::chefclient"
include_recipe "iptables::default"
iptables_rule "port_chef"

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

template "/etc/security/limits.conf.erb" do
  source "limits.conf"
  owner  "root"
  group  "root"
  mode   "0644"
end

%w{gcc make ruby-devel libxml2 libxml2-devel libxslt libxslt-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "bundle install" do
  cwd '/home/rtnextgen/chef-repo'
  path ['/opt/chef/embedded/bin']
  action :run
end

service "chef-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end
