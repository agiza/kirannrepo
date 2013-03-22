#
# Cookbook Name:: altisource
# Recipe:: rhel-local
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "yum" do
  command "yum clean all"
  action :nothing
end

yumserver_search do
end
yumserver = node[:yumserver]
template "/etc/yum.repos.d/rhel-local.repo" do
  source "rhel-local.repo.erb"
  mode "0644"
  variables(:yumserver => yumserver)
  notifies :run, resources(:execute => "yum")
end

