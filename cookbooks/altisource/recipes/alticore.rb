#
# Cookbook Name:: altisource
# Recipe:: alticore
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::yumclient"

execute "yum" do
  command "yum clean all"
  action :nothing
end

if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = {}
  search(:node, 'recipes:infrastructure\:\:yumserver') do |n|
    yumserver[n.ipaddress] = {}
  end
end
yumserver = yumserver.first
template "/etc/yum.repos.d/alticore.repo" do
  source "alticore.repo.erb"
  mode "0644"
  variables(:yumserver => yumserver)
  notifies :run, resources(:execute => "yum")
end

