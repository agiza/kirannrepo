#
# Cookbook Name:: implementer
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "implementer"

#include_recipe "altitomcat"

yum_package "#{app_name}" do
  action :upgrade
end

template "/opt/tomcat/startup.xml" do
  source "startup.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
end

ruby_block "remove implementer from run list" do
  block do
    node.roles.remove['implementer']
  end
end

