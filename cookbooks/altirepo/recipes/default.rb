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

realapps = data_bag_item("real_apps", "names")

template "/etc/yum.repos.d/altisource.repo" do
  source "altisource.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
  variables(
    :app_names => realapps['appnames'],
    :common_names => realapps['common_names']
  )
end

template "/etc/sysconfig/network" do
  source "network.erb"
  mode "0644"
  owner "root"
  group "root"
end
