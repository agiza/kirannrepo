#
# Cookbook Name:: integration
# Recipe:: realsvc-sim
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realsvc-sim"
app_version = node[:realsvcsim_version]

include_recipe "altisource::altitomcat"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

#yum_package "#{app_name}" do
#  version "#{app_version}"
#  if node.attribute?('package_noinstall')
#    action :nothing
#  else
#    action :install
#  end
#  flush_cache [ :before ]
#  allow_downgrade true
#  notifies :restart, resources(:service => "altitomcat")
#end

template "/opt/tomcat/conf/realservicing.simulator.properties" do
  source "realservicing.simulator.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/int-realservicing-simulator.xml" do
  source "int-realservicing-simulator.xml.erb"
  group  "tomcat"
  owner  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

