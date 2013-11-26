#
## Cookbook Name:: infrastructure
## Recipe:: stash
##
## Copyright 2013, Altisource
##
## All rights reserved - Do Not Redistribute
##
## JSM: modeling for stash system
##  
app_name = "stash"
#
#
## JSM: install base set of packages if not installed already
#
#%w{telnet lynx traceroute}.each do |pkg|
#  package pkg do
#    action :upgrade
#  end
#end
#
#
include_recipe "java::oracle"
include_recipe "mysql::server"
include_recipe "mysql::client"
