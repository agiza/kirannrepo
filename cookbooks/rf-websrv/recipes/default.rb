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


include_recipe "iptables::disabled"
#include_recipe "apache2::mod_proxy_ajp"
#include_recipe "apache2::mod_proxy_balancer"
#include_recipe "apache2::mod_proxy_connect"
#include_recipe "apache2::mod_proxy_http"
#include_recipe "apache2::mod_proxy"
include_recipe "tomcat-all"

#include_recipe "shibboleth-sp"
#include_recipe "shibboleth-sp::simple"
