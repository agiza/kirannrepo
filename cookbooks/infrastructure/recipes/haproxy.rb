#
# Cookbook Name:: infrastructure
# Recipe:: haproxy
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "haproxy"

package "haproxy" do
  action :upgrade
end

service "haproxy" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

service "haproxy" do
  action [:enable, :start]
end

