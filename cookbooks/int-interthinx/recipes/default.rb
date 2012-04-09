#
# Cookbook Name:: int-interthinx
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-interthinx"
include_recipe "altitomcat"

package {app_name} do
  version "node[{app_name}_version].noarch"
  action :install
end

template "/opt/tomcat/conf/{app-name}.properties" do
  source "{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

