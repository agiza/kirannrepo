#
# Cookbook Name:: rf-iam-mysql
# Recipe:: rf-mysqlhaproxy
#
# Copyright 2015, Altisource Labs, Inc
#
# All rights reserved - Do Not Redistribute
#
#include_recipe "mysql::client"
include_recipe "haproxy::app_lb" 
include_recipe "haproxy::install_package" 

include_recipe "haproxy::default"
include_recipe  "rsyslog::server"
begin
	r = resources(:template => "#{node['haproxy']['conf_dir']}/haproxy.cfg")
	r.cookbook "rf-iam-mysql"
	r.source "haproxy.cfg.erb"
end

template "#{node['rsyslog']['config_prefix']}/haproxy.conf" do
  source  'haproxy.conf.erb'
  owner   'root'
  group   'root'
  mode    '00644'
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end