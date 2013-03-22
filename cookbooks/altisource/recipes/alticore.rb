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

yumserver_search do
end
yumserver = node[:yumserver]
template "/etc/yum.repos.d/alticore.repo" do
  source "alticore.repo.erb"
  mode "0644"
  variables(:yumserver => yumserver)
  notifies :run, resources(:execute => "yum")
end

