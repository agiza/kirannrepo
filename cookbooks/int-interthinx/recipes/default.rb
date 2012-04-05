#
# Cookbook Name:: int-interthinx
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altitomcat"

package "int-interthinx" do
  version "node[int_interthinx_version].noarch"
  action :install
end

template "/opt/tomcat/conf/int-interthinx.properties" do
  source "int-interthinx.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

