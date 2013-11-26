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
include_recipe "infrastructure::base"

default_attributes(
  :java => {
     :oracle => {
       "accept_oracle_download_terms" => true
     }
   }
)
include_recipe "java::oracle"

#include_recipe "mysql::server"
#include_recipe "mysql::client"
