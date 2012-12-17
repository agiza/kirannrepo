#
# Cookbook Name:: altisource
# Recipe:: deployer
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

group "rtnextgen" do
  gid 1001
end

user "rtnextgen" do
  comment "rtnextgen User"
  uid 1001
  gid 1001
  home "/home/rtnextgen"
  shell "/bin/bash"
end

directory "/home/rtnextgen/bin" do
  owner "rtnextgen"
  group "rtnextgen"
  action :create
end

app_names = data_bag_item("infrastructure", "applications")
template "/home/rtnextgen/bin/chef-deploy" do
  source "chef-deploy.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
  variables(
    :appnames => app_names['names']
  )
end

template "/home/rtnextgen/bin/chef-cookbook-upload" do
  source "chef-cookbook-upload.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
end

template "/home/rtnextgen/bin/deploy-software" do
  source "deploy-software.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
  variables(
    :appnames => app_names['names']
  )
end


