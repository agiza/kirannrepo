#
# Cookbook Name:: rsng
# Recipe:: rsng-server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rsng::replication-app"
include_recipe "rsng::rsng-server-app"

