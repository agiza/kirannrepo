#
# Cookbook Name:: rf-websrv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

yum_package "httpd" do 
  action :upgrade
end

yum_package "mod_ssl" do
  action :upgrade
end


include_recipe "shibboleth_sp"
