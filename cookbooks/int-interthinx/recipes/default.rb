#
# Cookbook Name:: int-interthinx
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-interthinx"
app_version = node[:intinterthinx_version]

include_recipe "altitomcat"

package "#{app_name}" do
  version "#{app_version}.noarch"
  action :install
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

