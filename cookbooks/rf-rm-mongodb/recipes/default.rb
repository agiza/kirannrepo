#
# Cookbook Name:: rf-rm-mongodb
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

directory "/data" do
  owner "root"
  group "root"
  mode 00777
  action :create
end

directory "/data/db" do
  owner "root"
  group "root"
  mode 00777
  action :create
end

yum_package "cyrus-sasl-devel" do
   action :install
end

include_recipe "iptables::disabled"

