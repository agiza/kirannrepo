#
# Cookbook Name:: infrastructure
# Recipe:: dns
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "infrastructure::selinux"

package "bind" do
  action :upgrade
  notifies :run, resources(:execute => "permissive")
end

package "bind-utils" do
  action :upgrade
end

service "named" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

zones = data_bag_item("infrastructure", "dns")
template "/etc/named.conf" do
  source "named.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
  variables( :dnsmaster => zones['dnsmaster'] )
end

template "/etc/rndc.key" do
  source "rndc.key.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

service "named" do
  action [:enable, :start]
end


