#
# Cookbook Name:: int-corelogic
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-corelogic"
app_version = node[:intcorelogic_version]

include_recipe "altitomcat"

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

