# Recipe:: erlang
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "yum" do
  command "yum clean all"
  action :nothing
end

template "/etc/yum.repos.d/epel-erlang.repo" do
  source "erlang.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
end

