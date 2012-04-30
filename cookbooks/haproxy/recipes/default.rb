#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "haproxy"

service "haproxy" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

yum_package "#{app_name}" do
  action :update
  notifies :restart, resources(:service => "haproxy")
end

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  group "haproxy"
  owner "haproxy"
  mode "0644"
  notifies :restart, resources(:service => "haproxy")
end

