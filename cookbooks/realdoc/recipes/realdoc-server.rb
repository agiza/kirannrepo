#
# Cookbook Name:: realdoc
# Recipe:: realdoc-server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "realdoc::realdoc"
include_recipe "realdoc::rd-correspondence"
include_recipe "realdoc::realsvc-recon-adapter"
include_recipe "realdoc::strongmail-adapter"
include_recipe "realdoc::rd-print-recon"
include_recipe "realdoc::rd-transcentra-recon"
include_recipe "realdoc::rd-proxy-image-generator"

