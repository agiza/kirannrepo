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

case node[:testing_setting]
when "1" 
  testing_setting = "1"
else
  testing_setting = "0"
end
template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
  variables(
    :testing_setting => testing_setting,
    :release_setting => "0"
  )
  notifies :run, resources(:execute => "yum")
end

