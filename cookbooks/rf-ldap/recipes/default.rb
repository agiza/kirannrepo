#
# Cookbook Name:: rf-ldap
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
include_recipe "java"
include_recipe "tomcat-all"
include_recipe "opendj"

yum_package "apacheds" do 
    action  :upgrade
end
