#
# Cookbook Name:: rf-app
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#
execute "stop tomcat" do
   command "/etc/init.d/tomcat stop"
end



include_recipe "java"
include_recipe "tomcat-all"
include_recipe "shibboleth_idp"
