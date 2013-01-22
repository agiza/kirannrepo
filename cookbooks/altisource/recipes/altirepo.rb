#
# Cookbook Name:: altisource
# Recipe:: altirepo
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

if node[:testing_setting].nil? || node[:testing_setting].empty?
  testing_setting = "0"
else
  testing_setting = node[:testing_setting]
end
template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
  variables(
    :testing_setting => testing_setting,
    :release_setting => "1"
  )
  notifies :run, resources(:execute => "yum")
end

