#
# Cookbook Name:: realtrans
# Recipe:: realtrans-server
#

include_recipe "realtrans::realtrans-central"
include_recipe "realtrans::realtrans-rp"
include_recipe "realtrans::realtrans-fp"
include_recipe "realtrans::realtrans-vp"
include_recipe "realtrans::realtrans-reg"

