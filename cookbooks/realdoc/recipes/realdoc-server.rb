#
# Cookbook Name:: realdoc
# Recipe:: realdoc-server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "realdoc::realdoc"
include_recipe "realdoc::jdbc-data-provider"
include_recipe "realdoc::realsvc-recon-adapter"

