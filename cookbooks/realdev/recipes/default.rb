#
# Cookbook Name:: realdev
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

#template "/root/mount-opt.sh" do
#  source "mount-opt.sh.erb"
#  owner  "root"
#  group  "root"
#  mode   "0755"
#end

#execute "mountopt" do
#  command "/root/mount-opt.sh"
#  creates "/opt/lost+found"
#  action  :run
#end

template "/root/tomcat-clean.sh" do
  source "tomcat-clean.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

include_recipe "infrastructure::rookey"

