#
# Cookbook Name:: realtrans-rp
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
app_name = "realtrans-rp"
app_version = node[:realtrans_rp_version]

package "#{app_name}" do
  version "#{app_version}"
  action :install
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

