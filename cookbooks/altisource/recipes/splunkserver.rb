#
# Cookbook Name:: altisource
# Recipe:: splunkserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "splunk" do
  #version "4.3.3-128297"
  case node[:kernel][:machine]
  when "i386","i686"
    arch "i386"
  when "x86_64"
    arch "x86_64"
  end
  action :upgrade
end

service "splunk" do
  supports :stop => true, :start => true, :reload => true, :restart => true
  action :nothing
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

service "splunk" do
  action [:enable, :start]
end

