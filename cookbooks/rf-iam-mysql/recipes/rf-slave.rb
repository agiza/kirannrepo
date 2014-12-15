#
# Cookbook Name:: rf-iam-mysql
# Recipe:: rf-slave
#
# Copyright 2014, Altisource Labs, Inc
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rf-iam-mysql::rf-storage"
include_recipe "mysql-multi::mysql_slave"
include_recipe "rf-iam-mysql::rf-base"

service "mysqld" do
  action :restart
end
