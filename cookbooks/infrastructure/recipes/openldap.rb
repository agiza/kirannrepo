#
# Cookbook Name:: infrastructure
# Recipe:: openldap
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

service "slapd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

package "openldap-servers" do
  action :upgrade
  notifies :restart, resources(:service => "slapd")
end

service "slapd" do
  action [:enable, :start]
end

