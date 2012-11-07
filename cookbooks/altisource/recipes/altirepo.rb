#
# Cookbook Name:: altisource
# Recipe:: altirepo
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "yumclient"

execute "yum" do
  command "yum clean all"
  action :nothing
end

template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
end

