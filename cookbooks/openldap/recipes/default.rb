#
# Cookbook Name:: openldap
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

service "slapd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

package "openldap-servers" do
  action :update
  notifies :restart, resources(:service => "slapd")
end

