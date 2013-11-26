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
#
set[:java][:install_flavor]="oracle" 
set[:java][:accept_oracle_download_terms]=true 
set[:java][:jdk_version]='7'
include_recipe "java::oracle"

#include_recipe "mysql::server"
#include_recipe "mysql::client"
