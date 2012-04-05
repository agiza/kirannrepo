#
# Cookbook Name:: int-etrac
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altitomcat"

package "int-etrac" do
  version "node[int_etrac_version].noarch"
  action :install
end

template "/opt/tomcat/conf/int-etrac.properties" do
  source "int-etrac.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

