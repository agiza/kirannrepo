#
# Cookbook Name:: hostname
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init.d/host_command" do
  source "host_command.erb"
  mode "0755"
  owner "root"
  group "root"
end

if platform?("redhat", "centos", "fedora")
  execute "chkconfig" do
    command "chkconfig --add host_command; chkconfig host_command on"
    action :run
  end
end

if platform?("ubuntu")
  execute "update-rc" do
    command "sudo update-rc.d host_command defaults; sudo update-rc.d host_command enable"
    action :run
  end
end

