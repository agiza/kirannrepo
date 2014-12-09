#
# Cookbook Name:: rf-iam-mysql
# Recipe:: default
#
# Copyright 2014, Altisource Labs, Inc
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rf-iam-mysql::rf-storage"
include_recipe "mysql-multi::default"
include_recipe "rf-iam-mysql::rf-base"

service "mysqld" do
  action :restart
end