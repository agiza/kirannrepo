#
# Cookbook Name:: altirepo
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "yum" do
  command "yum clean all"
  action :nothing
end

template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
end

template "/etc/sysconfig/network" do
  source "network.erb"
  mode "0644"
  owner "root"
  group "root"
end
