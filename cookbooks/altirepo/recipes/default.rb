#
# Cookbook Name:: altirepo
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
end

execute "yum" do
  command "yum clean all"
  action "run"
end
