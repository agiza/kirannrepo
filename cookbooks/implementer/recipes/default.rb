#
# Cookbook Name:: implementer
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "implementer"
app_version = node[:implementer_version]

include_recipe "altitomcat"

package "#{app_name}" do
  version "#{app_version}"
  action :install
end

ruby_block "remove implementer from run list" do
  block do
    node.run_list.remove("recipe[implementer]")
  end
end

