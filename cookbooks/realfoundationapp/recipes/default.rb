#
# Cookbook Name:: realfoundationapp
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realfoundationapp"
app_version = node[:realfoundationapp_version]

include_recipe "altitomcat"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  action :install
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

execute "yum-reinstall" do
  command "yum reinstall -y #{app_name}-#{app_version}"
  creates "/opt/tomcat/webapps/#{app_name}.war"
  action :run
  only_if "test ! -f /opt/tomcat/webapps/#{app_name}.war"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realfoundationapp.properties" do
  source "realfoundationapp.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

