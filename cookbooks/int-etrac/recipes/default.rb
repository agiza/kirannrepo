#
# Cookbook Name:: int-etrac
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-etrac"
app_version = node[:intetrac_version]

include_recipe "altitomcat"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

package "#{app_name}" do
  version "#{app_version}.noarch"
  action :install
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

directory "/opt/tomcat/EtracRegistry" do
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
end

