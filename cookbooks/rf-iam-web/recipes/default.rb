#
# Cookbook Name:: rf-iam-web
# Recipe:: default
#
# Copyright 2014, Altisource Labs 
#
# All rights reserved - Do Not Redistribute
#

yum_package "iam-iam" do
    action :install
    version "#{node['iam-iam']['rpm']['version']}"
    allow_downgrade true
end

yum_package "iam-selfsvc" do
    action :install
    version "#{node['iam-selfsvc']['rpm']['version']}"
    allow_downgrade true
end

yum_package "iam-home" do
    action :install
    version "#{node['iam-home']['rpm']['version']}"
    allow_downgrade true
end

