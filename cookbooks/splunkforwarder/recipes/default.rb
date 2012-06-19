#
# Cookbook Name:: splunkforwarder
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

package "splunkforwarder" do
  version "4.3.2"
  action :install
end

service "splunkforwarder" do
  supports :stop => true, :start => true, :reload => true
  action :enable
end

template "/opt/splunkforwarder/etc/system/local/server.conf" do
  source "server.conf.erb"
  owner  "splunk"
  group  "splunk"
  mode   "0644"
  notifies :restart, resources(:service => "splunkforwarder")
end

template "/opt/splunkforwarder/etc/system/local/outputs.conf" do
  source "outputs.conf.erb"
  owner  "splunk"
  group  "splunk"
  mode   "0644"
  notifies :restart, resources(:service => "splunkforwarder")
end

template "/opt/splunkforwarder/etc/apps/search/local/inputs.conf" do
  source "inputs.conf.erb"
  owner  "splunk"
  group  "splunk"
  mode   "0644"
  notifies :restart, resources(:service => "splunkforwarder")
end

splunkindexes = data_bag_item("splunk_index", "indexes")
template "/opt/splunk/etc/apps/launcher/local/indexes.conf" do
  source "indexes.conf.erb"
  owner  "root"
  group  "root"
  mode   "0600"
  variables(
    :splunk_indexes => splunkindexes['indexes']
  )
  notifies :restart, resources(:service => "splunk")
end
