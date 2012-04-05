#
# Cookbook Name:: int-corelogic
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altitomcat"

package "int-corelogic" do
  version "node[int_corelogic_version].noarch"
  action :install
end

template "/opt/tomcat/conf/int-corelogic.properties" do
  source "int-corelogic.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

