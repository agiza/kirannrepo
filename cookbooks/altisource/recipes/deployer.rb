#
# Cookbook Name:: altisource
# Recipe:: deployer
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#



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


