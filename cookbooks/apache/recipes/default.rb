#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache::apache"

include_recipe "apache::rtvhost"
include_recipe "apache::rdvhost"
include_recipe "apache::l1vhost"
include_recipe "apache::rfvhost"
include_recipe "apache::rtevhost"

