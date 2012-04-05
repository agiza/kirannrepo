#
# Cookbook Name:: realtrans-fp
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altitomcat"

package "realtrans-fp" do
  version "node[realtrans_fp_version].noarch"
  action :install
end

template "/opt/tomcat/conf/realtrans-fp.properties" do
  source "realtrans-fp.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

