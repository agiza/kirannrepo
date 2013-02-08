#
# Cookbook Name:: altisource
# Recipe:: epel-local
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::yumclient"

package "epel-local" do
  action :upgrade
end

execute "yum" do
  command "yum clean all"
  action :nothing
end

if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = search(:node, "recipes:infrastructure\\:\\:yumserver OR recipes:github\\:\\:yum-repo")
  if yumserver.nil?  || yumserver.empty?
    Chef::Log.warn("No yum repositories found.") && yumserver = "127.0.0.1"
  else
    yumserver = yumserver.first
    yumserver = yumserver["ipaddress"]
  end
end
template "/etc/yum.repos.d/epel-local.repo" do
  source "epel-local.repo.erb"
  mode "0644"
  variables(:yumserver => yumserver)
  notifies :run, resources(:execute => "yum")
end

