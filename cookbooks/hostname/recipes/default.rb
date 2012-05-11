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
  when "debian", "ubuntu"
    command "sudo hostname #{host_name} "
  end
  action :run
end

execute "chkconfig" do
  case node[:platform]
  when "centos", "redhat", "fedora", "suse"
    command "chkconfig --add host_command; chkconfig host_command on"
  when "debian", "ubuntu"
    command "update-rc.d host_command defaults; update-rc.d host_command enable"
  end
  action :nothing
end

template "/etc/init.d/host_command" do
  source "host_command.erb"
  mode "0755"
  owner "root"
  group "root"
  notifies :run, resources(:execute => "chkconfig")
end

