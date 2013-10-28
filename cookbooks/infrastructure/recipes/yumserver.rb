#
# Cookbook Name:: infrastructure
# Recipe:: yumserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "iptables::default"
iptables_rule "port_http"

include_recipe "infrastructure::base"


yum_package "createrepo" do
  action :upgrade
end

yum_package "httpd" do
  action :upgrade
end

%w{/data/yum-repo /data/yum-repo/release /data/yum-repo/common /data/yum-repo/testing /data/yum-repo/rhel-x86_64-server-6 /data/yum-repo/rhel-x86_64-server-6/getPackage /data/yum-repo/epel}.each do |dir|
  directory "#{dir}" do
    owner "root"
    group "root"
    recursive true
  end
end

link "/var/www/html/yum-repo" do
  to "/data/yum-repo"
  owner "root"
  group "root"
end

link "/data/yum-repo/redhat" do
  to "/data/yum-repo/rhel-x86_64-server-6/getPackage"
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

