#
# Cookbook Name:: l1
# Recipe:: l1-server
#

include_recipe "l1::l1-central"
include_recipe "l1::l1-rp"
include_recipe "l1::l1-fp"

