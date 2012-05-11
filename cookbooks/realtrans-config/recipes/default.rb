#
# Cookbook Name:: realtrans-config
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

service "altitomcat" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

template "/opt/tomcat/conf/realtrans-central.properties" do
  source "realtrans-central.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realtrans-rp.properties" do
  source "realtrans-rp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realtrans-fp.properties" do
  source "realtrans-fp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end


