#
# Cookbook Name:: rm-rabbitmq
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe  'java'
include_recipe  'yum-epel'
include_recipe  'rabbitmq::default'
include_recipe  'rabbitmq::plugin_management'
include_recipe  'rabbitmq::user_management'
include_recipe  'rabbitmq::policy_management'
include_recipe  'rabbitmq::mgmt_console'
include_recipe  'rabbitmq::virtualhost_management'

cookbook_file "/tmp/setup_rabbit_production.sh" do
   source "setup_rabbit_production.sh"
   mode 00755
end

execute "Rabbit install script" do
   command '/tmp/setup_rabbit_production.sh'
end


include_recipe 'iptables::disabled'
