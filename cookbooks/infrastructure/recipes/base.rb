#
## Cookbook Name:: infrastructure
## Recipe:: base
##
## Copyright 2013, Altisource
##
## All rights reserved - Do Not Redistribute
##
## JSM: start modeling our base systems
##  JSM:  eventually this should be included in role[all]
##  
app_name = "base"
#
#
## JSM: install base set of packages if not installed already
#
%w{telnet lynx traceroute}.each do |pkg|
  package pkg do
    action :upgrade
  end
end
#
#
# JSM: apply updates on reboots
template "/etc/rc.d/rc.local" do
    source "rc.local.erb"
    owner  "root"
    group  "root"
    mode   "0755"
end
# JSM: custom sshd options to speed up logins / require cert auth
template "/etc/ssh/sshd_config" do
    source "sshd_config.erb"
    owner  "root"
    group  "root"
    mode   "0600"
end

