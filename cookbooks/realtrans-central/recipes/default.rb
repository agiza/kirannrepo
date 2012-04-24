#
# Cookbook Name:: realtrans-central
# Recipe:: default
#

#include_recipe "java"
app_name = "realtrans-central"
app_version = node[:realtranscentral_version]

include_recipe "altitomcat"

package "#{app_name}" do
  action :remove
end

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

service "altitomcat" do
  action :start
end

