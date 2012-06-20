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
  action :install
end

execute "splunk-first-run" do
  command "/opt/splunkforwarder/bin/splunk --accept-license"
  action :run
end

execute "splunk-boot-enable" do
  command "/opt/splunkforwarder/bin/splunk status > /dev/null; splunk_check=`echo $?`; if [ "$splunk_check" == "3" ]; then /opt/splunkforwarder/bin/splunk start; fi; /opt/splunkforwarder/bin/splunk enable boot-start -user splunk"
  action :run
end

service "splunk" do
  supports :stop => true, :start => true, :reload => true
  action :nothing
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

