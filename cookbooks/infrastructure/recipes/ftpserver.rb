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

template "/etc/vsftpd/vsftpd.conf" do
  source "vsftpd.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "vsftpd")
end

template "/etc/vsftpd/email_passwords" do
  source "vsftpd.email_passwords.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "vsftpd")
end

directory "/var/ftp/pub" do
  owner "root"
  group "ftp"
end

targetdirs = data_bag_item("infrastructure", "applications")
targetdirs = targetdirs["ftptarget"].split(" ")
targetdirs.each do |target|
  directory "/var/ftp/pub/#{target}" do
    owner "ftp"
    group "ftp"
  end
  directory "/var/ftp/pub/#{target}/input" do
    owner "ftp"
    group "ftp"
  end
  directory "/var/ftp/pub/#{target}/archive" do
    owner "ftp"
    group "ftp"
  end
  directory "/var/ftp/pub/#{target}/error" do
    owner "ftp"
    group "ftp"
  end
end
   
service "vsftpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :start
end


