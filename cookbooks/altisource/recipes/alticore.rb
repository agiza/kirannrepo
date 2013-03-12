#
# Cookbook Name:: altisource
# Recipe:: alticore
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "yum" do
  command "yum clean all"
  action :nothing
end

if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = search(:node, "recipes:infrastructure\\:\\:yumserver OR recipes:github\\:\\:yum-repo")
  yumserver = yumserver.first
  yumserver = yumserver["ipaddress"]
end
yumserver = yumserver.first
template "/etc/yum.repos.d/alticore.repo" do
  source "alticore.repo.erb"
  mode "0644"
  variables(:yumserver => yumserver)
  notifies :run, resources(:execute => "yum")
end

