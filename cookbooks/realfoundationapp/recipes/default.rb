#
# Cookbook Name:: realfoundationapp
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realfoundationapp"
app_version = node[:realfoundationapp_version]

include_recipe "altitomcat"

package "#{app_name}" do
  version "#{app_version}"
  action :install
end

template "/opt/tomcat/conf/realfoundationapp.properties" do
  source "realfoundationapp.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

