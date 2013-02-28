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

%w[/home/rtnextgen /home/rtnextgen/bin /home/rtnextgen/chef-repo /home/rtnextgen/.chef].each do |dir|
  directory dir do
    owner "rtnextgen"
    group "rtnextgen"
    action :create
  end
end

if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = search(:node, "recipes:infrastructure\\:\\:yumserver OR recipes:github\\:\\:yum-repo")
  yumserver = yumserver.first
  yumserver = yumserver["ipaddress"]
end

#app_names = data_bag_item("infrastructure", "applications")
app_names = node[:app_names]
template "/home/rtnextgen/bin/chef-deploy" do
  source "chef-deploy.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
  variables(
    :appnames => app_names,
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
    :appnames => app_names
  )
end

template "/home/rtnextgen/bin/chef-provision" do
  source "chef-provision.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
  variables(
    :appnames => app_names
  )
end
%w[/home/rtnextgen/.chef /home/rtnextgen/.chef/plugins /home/rtnextgen/.chef/plugins/knife].each do |dir|
  directory dir do
    owner "rtnextgen"
    group "rtnextgen"
    action :create
  end
end

template "/home/rtnextgen/.chef/plugins/knife/set_environment.rb" do
  source "set_environment.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0644"
end
 

