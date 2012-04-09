#
# Cookbook Name:: realtrans-central
# Recipe:: default
#

#include_recipe "java"
app_name = "realtrans-central"
include_recipe "altitomcat"

package "#{app_name}" do
  version "node[#{app_name}_version].noarch"
  action :install
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

