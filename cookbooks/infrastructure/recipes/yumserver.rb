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
  to "/data/yum-repo"
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

directory "/data/yum-repo/rhel-x86_64-server-6" do
  owner  "root"
  group  "root"
end

directory "/data/yum-repo/rhel-x86_64-server-6/getPackage" do
  owner  "root"
  group  "root"
end

link "/data/yum-repo/redhat" do
  to "/data/yum-repo/rhel-x86_64-server-6/getPackage"
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

if node.attribute?("denveryumserver")
  template "/usr/local/bin/local-repo-update" do
    source "prod-repo-update.erb"
    owner  "root"
    group  "root"
    mode   "0755"
    variables(:denveryumserver => node[:denveryumserver])
  end
  template "/usr/local/bin/altidev-update" do
    source "altidev-update.erb"
    owner  "root"
    group  "root"
    mode   "0755"
  end
  template "/etc/yum.repos.d/altidev.repo" do
    source "altidev.repo.erb"
    owner  "root"
    group  "root"
    mode   "0644"
  end
else
  template "/usr/local/bin/local-repo-update" do
    source "local-repo-update.erb"
    owner  "root"
    group  "root"
    mode   "0755"
  end
end

template "/etc/httpd/conf.d/yum.conf" do
  source "yum.conf.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :restart, resources(:service => "httpd")
end

cron "altidev-update" do
  minute "0,10,20,30,40,50"
  user  "root"
  command "/usr/local/bin/altidev-update > /dev/null 2>&1"
end

