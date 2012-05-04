#
# Cookbook Name:: hostname
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "update-rc" do
  command "update-rc.d host_command defaults; update-rc.d host_command enable"
  action :nothing
end

execute "chkconfig" do
  command "chkconfig --add host_command; chkconfig host_command on"
  action :nothing
end

template "/etc/init.d/host_command" do
  source "host_command.erb"
  mode "0755"
  owner "root"
  group "root"
  if platform?("redhat", "centos", "fedora")
     notifies :run, resources(:execute => "chkconfig")
  end

  if platform?("ubuntu")
     notifies :run, resources(:execute => "update-rc")
  end

end

