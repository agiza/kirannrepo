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
  case node[:chef_environment]
  when "Dev","Intdev"
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realfoundationapp.properties" do
  source "realfoundationapp.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/realfoundationapp.xml" do
  source "realfoundationapp.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end
