#
# Cookbook Name:: create
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'zookeeper'
include_recipe 'mesos'
include_recipe 'hadoop::hive'
include_recipe 'spark-shark-cookbook::shark'
#include_recipe 'spark-shark-cookbook::spark'
