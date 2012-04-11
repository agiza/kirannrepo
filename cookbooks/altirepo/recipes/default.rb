#
# Cookbook Name:: altirepo
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "yum_clean" do
  command "yum clean all"
  action "nothing"
end

template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum_clean")
end

