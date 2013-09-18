#
# Cookbook Name:: altisource
# Recipe:: epel-local
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

package "epel-release" do
  action :remove
end

package "epel-local" do
  action :upgrade
end

execute "yum" do
  command "yum clean all"
  action :nothing
end

yumserver_search do
end
yumserver = node[:yumserver]
template "/etc/yum.repos.d/epel-local.repo" do
  source "epel-local.repo.erb"
  mode "0644"
  variables(:yumserver => yumserver)
  notifies :run, resources(:execute => "yum")
end

