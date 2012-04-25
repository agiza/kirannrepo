#
# Cookbook Name:: realtrans-rp
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
app_name = "realtrans-rp"
app_version = node[:realtransrp_version]

include_recipe "altitomcat"

package "#{app_name}" do
  version "#{app_version}.noarch"
  action :install
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realtrans-rp.properties" do
  source "realtrans-rp.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

