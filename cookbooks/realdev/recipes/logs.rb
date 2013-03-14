#
# Cookbook Name:: infrastructure
# Recipe:: logs
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::selinux"
include_recipe "iptables::default"

iptables_rule "port_http"

package "httpd" do
  action :upgrade
end

template "/usr/local/bin/iptables-httpd.sh" do
  source "iptables-httpd.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

execute "iptables_httpd" do
  command "/usr/local/bin/iptables-httpd.sh"
  creates "/usr/local/bin/iptables-httpd.log"
  action :run
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action  :enable
end

template "/etc/httpd/conf.d/logs.conf" do
  source "logs.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/conf.conf" do
  source "conf.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "httpd")
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :start
end


