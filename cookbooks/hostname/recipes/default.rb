#
# Cookbook Name:: hostname
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

host_name=node[:name]
execute "hostname" do
  case node[:platform]
  when "centos", "redhat", "fedora", "suse"
    command "hostname #{host_name} "
    action :run
  when "debian", "ubuntu"
    command "sudo hostname #{host_name} "
    action :run
  end
end

execute "chkconfig" do
  command " chkconfig host_command enable"
  action :nothing
end

execute "update-rc.d" do
  command "update-rc.d host_command defaults; update-rc.d host_command enable"
  action :nothing
end

template "/etc/init.d/host_command" do
  source "host_command.erb"
  mode "0755"
  owner "root"
  group "root"
  case node[:platform]
  when "centos", "redhat", "fedora", "suse"
    notifies :run, resources(:execute => "chkconfig")
  when "debian", "ubuntu"
    notifies :run, resources(:execute => "update-rc.d")
  end
end

