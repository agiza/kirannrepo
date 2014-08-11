#
# Cookbook Name:: rf-search-app
# Recipe:: index-srv 
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "java"
include_recipe "iptables::disabled"
include_recipe "tomcat-all"

template "/opt/tomcat/conf/rf-realsearch.properties" do
  source "rf-realsearch.properties.erb"
  mode 0775
  owner "tomcat"
  group "tomcat"
end

yum_package "realsearch-indexservice" do 
    action  :upgrade
end

service "tomcat" do 
  action :restart
end
