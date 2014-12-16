#
# Cookbook Name:: rf-iam-web
# Recipe:: default
#
# Copyright 2014, Altisource Labs 
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rf-apache-shib-sp"

yum_package "iam-iam" do
    action :install
    version "#{node['iam']['rpm']['version']}"
    allow_downgrade true
end

yum_package "iam-selfsvc" do
    action :install
    version "#{node['iam']['rpm']['version']}"
    allow_downgrade true
end

yum_package "iam-home" do
    action :install
    version "#{node['iam']['rpm']['version']}"
    allow_downgrade true
end

# replace ssl.conf using my own
template "/etc/httpd/conf.d/ssl.conf" do
   source "ssl.conf.erb"
     owner "root"
     group "root"
     mode  0775
end

service "shibd" do
  action :restart
end

service "httpd" do
  action :restart
end
