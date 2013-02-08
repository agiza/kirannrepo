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

if node.attribute?('testing_setting')
  testing_setting = node[:testing_setting]
else
  testing_setting = "0"
end
if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = search(:node, "recipes:infrastructure\\:\\:yumserver OR recipes:github\\:\\:yum-repo") 
  if yumserver.nil? || yumserver.empty?
    Chef::Log.info("No yum repositories found.") && yumserver = "127.0.0.1"
  else
    yumserver = yumserver.first
    yumserver = yumserver["ipaddress"]
  end
end
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

