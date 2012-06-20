#
# Cookbook Name:: splunkforwarder
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "splunkforwarder" do
  version "4.3.2-123586"
  case node[:kernel][:machine]
  when "i386"
    arch "i386"
  when "x86_64"
    arch "x86_64"
  end
  flush_cache [ :before ]
  action :install
end

execute "first_start" do
  command "su -c \"/opt/splunkforwarder/bin/splunk start --accept-license\" splunk"
  action :nothing
end

template "/etc/init.d/splunk" do
  source "splunk.init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, resources(:execute => "first_start")
end

service "splunk" do
  supports :stop => true, :start => true, :reload => true
  action :enable
end

directory "/opt/splunkforwarder/etc/apps/search/local" do
  owner "splunk"
  group "splunk"
end

template "/opt/splunkforwarder/etc/system/local/server.conf" do
  source "server.conf.erb"
  owner  "splunk"
  group  "splunk"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunkforwarder/etc/system/local/outputs.conf" do
  source "outputs.conf.erb"
  owner  "splunk"
  group  "splunk"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunkforwarder/etc/apps/search/local/inputs.conf" do
  source "inputs.conf.erb"
  owner  "splunk"
  group  "splunk"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

