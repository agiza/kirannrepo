#
# Cookbook Name:: realtrans-central
# Recipe:: default
#

#include_recipe "java"
include_recipe "altitomcat"

package "realtrans-central" do
  version "node[realtrans_central_version].noarch"
  action :install
end

template "/opt/tomcat/conf/realtrans-central.properties" do
  source "realtrans-central.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

