# Recipe:: rbel6
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

template "/etc/yum.repos.d/rbel6.repo" do
  source "rbel6.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
end

