#
# Cookbook Name:: rf-rabbitmq
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe  'yum-epel'
include_recipe  'rabbitmq::default'
include_recipe  'rabbitmq::plugin_management'
include_recipe  'rabbitmq::user_management'
include_recipe  'rabbitmq::policy_management'
include_recipe  'rabbitmq::mgmt_console'
include_recipe  'rabbitmq::virtualhost_management'
