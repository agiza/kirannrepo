#
# Cookbook Name:: splunkforwarder
# Recipe:: server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

package "splunk" do
  #version "4.3.3-128297"
  provider Chef::Provider::Package::Yum
  case node[:kernel][:machine]
  when "i386"
    arch "i386"
  when "x86_64"
    arch "x86_64"
  end
  action :upgrade
end

service "splunk" do
  supports :stop => true, :start => true, :reload => true, :restart => true
  action [:enable, :start]
end

splunkindexes = data_bag_item("splunk_index", "indexes")
splunk_indexes = splunkindexes['indexes'].split(',')
template "/opt/splunk/etc/apps/search/local/indexes.conf" do
  source "server.indexes.conf.erb"
  owner  "root"
  group  "root"
  mode   "0600"
  variables(
    :splunk_indexes => splunk_indexes
  )
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/system/local/server.conf" do
  source "server.server.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/apps/search/local/inputs.conf" do
  source "server.inputs.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/system/local/web.conf" do
  source "server.web.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/system/local/inputs.conf" do
  source "server.inputs.local.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end


