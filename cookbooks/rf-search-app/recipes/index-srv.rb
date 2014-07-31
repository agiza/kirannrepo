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
