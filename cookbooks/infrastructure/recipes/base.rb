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
#
#%w{telnet lynx traceroute httpd php php-mysql MySQL-server-advanced MySQL-client-advanced} do |pkg|
#  package pkg do
#    action :upgrade
#  end
#end
#
#
## JSM: install base set of packages if not installed already
#
yum_package "telnet" do
  action :upgrade
end
yum_package "lynx" do
  action :upgrade
end
yum_package "traceroute" do
  action :upgrade
end

execute "rc.local" do
  command "echo chef-client > /etc/rc.local"
  ignore_failure true
  action :run
end

