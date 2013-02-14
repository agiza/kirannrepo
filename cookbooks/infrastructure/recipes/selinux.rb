#
# Cookbook Name:: infrastructure
# Recipe:: selinux
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "permissive" do
  command "echo 0 > /selinux/enforce"
  :nothing
  only_if "test -f /selinux/enforce"
  not_if  do "grep '0' /selinux/enforce".empty? end
end

template "/etc/sysconfig/selinux" do
  source "selinux.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :run, resources(:execute => "permissive"), :immediately
end

