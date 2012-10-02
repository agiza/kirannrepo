# Recipe:: 10gen
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "yum" do
  command "yum clean all"
  action :nothing
end

template "/etc/yum.repos.d/10gen.repo" do
  source "10gen.repo.erb"
  mode "0644"
  notifies :run, resources(:execute => "yum")
end

