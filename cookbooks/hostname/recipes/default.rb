#
# Cookbook Name:: hostname
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "chkconfig" do
  command "chkconfig --add host_command; chkconfig host_command on"
  action :nothing
end

template "/etc/init.d/host_command" do
  source "host_command.erb"
  mode "0755"
  owner "root"
  group "root"
  notifies :run, resources(:execute => "chkconfig")
end

