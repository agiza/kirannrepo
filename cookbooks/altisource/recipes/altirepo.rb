#
# Cookbook Name:: altisource
# Recipe:: altirepo
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "yum" do
  command "yum clean all"
  action :nothing
end

if node.attribute?('testing_setting')
  testing_setting = node[:testing_setting]
else
  testing_setting = "0"
end

yumserver_search do
end
yumserver = node[:yumserver]
template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
  variables(
    :yumserver => yumserver,
    :testing_setting => testing_setting,
    :release_setting => "1"
  )
  notifies :run, resources(:execute => "yum")
end

