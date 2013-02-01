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

directory "/home/rtnextgen" do
  owner "rtnextgen"
  group "rtnextgen"
  action :create
end

directory "/home/rtnextgen/bin" do
  owner "rtnextgen"
  group "rtnextgen"
  action :create
end

if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = {}
  search(:node, 'run_list:recipe\[infrastructure\:\:yumserver\]') do |n|
    yumserver[n.ipaddress] = {}
  end
end
yumserver = yumserver.first
app_names = data_bag_item("infrastructure", "applications")
template "/home/rtnextgen/bin/chef-deploy" do
  source "chef-deploy.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
  variables(
    :appnames => app_names['names'],
    :yumserver => yumserver
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

template "/home/rtnextgen/bin/chef-provision" do
  source "chef-provision.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
  variables(
    :appnames => app_names['names']
  )
end

directory "/home/rtnextgen/.chef/plugins" do
  owner "rtnextgen"
  group "rtnextgen"
  action :create
end

directory "/home/rtnextgen/.chef/plugins/knife" do
  owner "rtnextgen"
  group "rtnextgen"
  action :create
end

template "/home/rtnextgen/.chef/plugins/knife/set_environment.rb" do
  source "set_environment.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0644"
end
 

