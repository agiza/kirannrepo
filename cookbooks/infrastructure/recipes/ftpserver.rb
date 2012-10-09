#
# Cookbook Name:: infrastructure
# Recipe:: ftpserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::selinux"

package "vsftpd" do
  action :upgrade
end

service "vsftpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action  :enable
end

group "rtftpuser" do
  gid 1001
end

user  "rtftpuser" do
  comment "RT FTP User"
  uid "1001"
  gid "rtftpuser"
  home "/opt/tomcat/temp"
  shell "/bin/bash"
end

template "/etc/vsftpd/vsftpd.conf" do
  source "vsftpd.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "vsftpd")
end

template "/etc/vsftpd/ftpusers" do
  source "ftpusers.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "vsftpd")
end

service "vsftpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :start
end


