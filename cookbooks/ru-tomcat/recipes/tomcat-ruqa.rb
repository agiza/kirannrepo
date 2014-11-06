#
# Cookbook Name:: ru-tomcat
# Recipe:: tomcat-instance1
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'chef-tomcat::default'

tomcat "ruqa" do 
 port 8080
 shutdown_port 8005
end

