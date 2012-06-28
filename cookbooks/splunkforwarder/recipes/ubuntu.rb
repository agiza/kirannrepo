#
# Cookbook Name:: splunkforwarder
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "splunkdownload" do
  user "ubuntu"
  cwd "/tmp"
  case node[:kernel][:machine]
  when "i386","i686"
    command "/usr/bin/wget -O /tmp/splunkforwarder-4.3.3-128297-linux-2.6-intel.deb http://10.0.0.20/yum/common/splunkforwarder-4.3.3-128297-linux-2.6-intel.deb"
    creates "/tmp/splunkforwarder-4.3.3-128297-linux-2.6-intel.deb"
  when "x86_64"
    command "/usr/bin/wget -O /tmp/splunkforwarder-4.3.3-128297-linux-2.6-amd64.deb http://10.0.0.20/yum/common/splunkforwarder-4.3.3-128297-linux-2.6-amd64.deb"
    creates "/tmp/splunkforwarder-4.3.3-128297-linux-2.6-amd64.deb"
  end
  action :run
end


dpkg_package "splunkforwarder" do
  version "4.3.3-128297"
  case node[:kernel][:machine]
  when "i386","i686"
    source "/tmp/splunkforwarder-4.3.3-128297-linux-2.6-intel.deb"
    provider "Chef::Provider::Package::Dpkg"
  when "x86_64"
    source "/tmp/splunkforwarder-4.3.3-128297-linux-2.6-amd64.deb"
    provider "Chef::Provider::Package::Dpkg"
  end
  action :upgrade
end

execute "first_start" do
  command "su -c \"/opt/splunkforwarder/bin/splunk start --accept-license --no-prompt --answer-yes\" splunk"
  action :run
end

execute "splunk_init" do
  command "/opt/splunkforwarder/bin/splunk enable boot-start"
  creates "/etc/init.d/splunk"
  action :run
end
  
#template "/etc/init.d/splunk" do
#  source "splunk.init.erb"
#  owner  "root"
#  group  "root"
#  mode   "0755"
#  notifies :run, resources(:execute => "first_start")
#end

service "splunk" do
  supports :stop => true, :start => true, :reload => true, :restart => true
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

