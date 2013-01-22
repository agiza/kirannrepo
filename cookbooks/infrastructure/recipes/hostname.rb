#
# Cookbook Name:: infrastructure
# Recipe:: hostname
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

host_name=node[:fqdn]
execute "hostname" do
  case node[:platform]
  when "centos", "redhat", "fedora", "suse"
    command "hostname #{host_name} "
    action :nothing
  when "debian", "ubuntu"
    command "sudo hostname #{host_name} "
    action :nothing
  end
end

template "/etc/init.d/host_command" do
  source "host_command.erb"
  mode "0755"
  owner "root"
  group "root"
  notifies :run, 'execute[hostname]', :immediately
end

case node[:platform]
when "centos", "redhat", "fedora", "suse"
  execute "chkconfig" do
    command " chkconfig host_command on"
    action :run
  end
when "debian", "ubuntu"
  execute "update-rc.d" do
    command "update-rc.d host_command defaults; update-rc.d host_command enable"
    action :run
  end
end

