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

template "/etc/yum.repos.d/alticore.repo" do
  source "alticore.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
end

