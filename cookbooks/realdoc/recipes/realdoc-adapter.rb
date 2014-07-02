#
# Cookbook Name:: realdoc
# Recipe:: realdoc-adapter
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "realdoc::strongmail-adapter"
#include_recipe "realdoc::rd-mailmerge-adapter"
include_recipe "realdoc::realservicing-correspondence-adapter"
include_recipe "realdoc::realservicing-correspondence-adapter-tp2"
include_recipe "realdoc::realsvc-recon-adapter"
include_recipe "realdoc::rd-transcentra-recon"
include_recipe "realdoc::adm-print-recon-adapter"
include_recipe "realdoc::hov-print-recon-adapter"
include_recipe "realdoc::walz-print-recon-adapter"
include_recipe "realdoc::adapter-ods-request"
