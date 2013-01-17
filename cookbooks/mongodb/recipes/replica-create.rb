#
# Cookbook Name:: mongodb
# Recipe:: replica-create
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

#include_recipe "altitomcat"

execute "replica-create" do
  command "/usr/local/bin/replica-create"
  action :nothing
end

template "/etc/mongo/rsadd.js" do
  source "rsadd.js.erb"
  owner  "root"
  group  "root"
  mode   "0644"
 # notifies :run, 'execute[replica-create]'
end

template "/usr/local/bin/replica-create" do
  source "replica-create.erb"
  owner  "root"
  group  "root"
  mode   "0755"
 # notifies :run, 'execute[replica-create]'
end

ruby_block "remove replica-create from run list" do
  block do
    node.run_list.remove("mongodb::replica-create")
  end
end

