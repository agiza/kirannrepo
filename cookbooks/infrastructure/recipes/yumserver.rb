#
# Cookbook Name:: infrastructure
# Recipe:: yumserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "createrepo" do
  action :upgrade
end

yum_package "httpd" do
  action :upgrade
end

directory "/data/yum-repo" do
  owner "root"
  group "root"
end

link "/var/www/html/yum-repo" do
  target "/data/yum-repo"
  owner "root"
  group "root"
end

directory "/data/yum-repo/release" do
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/common" do
  owner "root"
  group "root"
end

directory "/data/yum-repo/testing" do
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/ruby" do
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/ruby/gems" do
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/rbel" do
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/rhel-x86_64-server-6" do
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/rhel-x86-server-6/getPackage" do
  owner  "root"
  group  "root"
end

link "/data/yum-repo/rhel-x86-server-6/getPackage" do
  source "/data/yum-repo/redhat"
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/epel" do
  owner  "root"
  group  "root"
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

template "/usr/local/bin/yum-update" do
  source "yum-update.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/usr/local/bin/local-repo-update" do
  source "local-repo-update.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/httpd/conf.d/yum.conf" do
  source "yum.conf.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :restart, resources(:service => "httpd")
end

cron "yum-update" do
  minute "0,10,20,30,40,50"
  user  "root"
  command "/usr/local/bin/yum-update > /dev/null 2>&1"
end

