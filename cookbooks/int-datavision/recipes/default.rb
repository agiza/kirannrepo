#
# Cookbook Name:: int-datavision
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altitomcat"

package "int-datavision" do
  version "node[int_datavision_version].noarch"
  action :install
end

template "/opt/tomcat/conf/int-datavision.properties" do
  source "int-datavision.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

