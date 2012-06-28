#
# Cookbook Name:: splunkforwarder
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "splunkforwarder" do
  version "4.3.3-128297"
  case node[:kernel][:machine]
  when "i386","i686"
    arch "i386"
  when "x86_64"
    arch "x86_64"
  end
  action :upgrade
end

execute "first_start" do
  command "su -c \"/opt/splunkforwarder/bin/splunk start --accept-license --no-prompt --answer-yes && touch /var/opt/splunkforwarder/first_run\" splunk"
  creates "/opt/splunkforwarder/first_run"
  action :run
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
  action [:enable, :start]
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

