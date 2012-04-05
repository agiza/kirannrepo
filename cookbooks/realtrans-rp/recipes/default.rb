#
# Cookbook Name:: realtrans-rp
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altitomcat"

package "realtrans-rp" do
  version "node[realtrans_rp_version].noarch"
  action :install
end

template "/opt/tomcat/conf/realtrans-rp.properties" do
  source "realtrans-rp.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

