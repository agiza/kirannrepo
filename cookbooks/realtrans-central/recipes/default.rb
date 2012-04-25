#
# Cookbook Name:: realtrans-central
# Recipe:: default
#

#include_recipe "java"
app_name = "realtrans-central"
app_version = node[:realtranscentral_version]

include_recipe "altitomcat"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

package "#{app_name}" do
  version "#{app_version}"
  action :update
  only_if "test -f /opt/tomcat/#{app_name}.war"
  notifies :restart, resources(:service => "altitomcat")
end

package "#{app_name}" do
  version "#{app_version}"
  action :install
  only_if "test ! -f /opt/tomcat/#{app_name}.war"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

