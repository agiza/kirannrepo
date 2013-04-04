#
# Cookbook Name:: infrastructure
# Recipe:: authkey
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

authkeys = data_bag_item("infrastructure", "authkeys")
template "/root/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  owner "root"
  group "root"
  mode  "0600"
  variables(:authkeys => authkeys)
  action :create
end


