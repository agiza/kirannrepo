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

template "/etc/yum.repos.d/epel-local.repo" do
  source "epel-local.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
end

