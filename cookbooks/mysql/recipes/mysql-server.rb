#
# Cookbook Name:: mysql
# Recipe:: mysql-server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"
include_recipe "mysql::default"

service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

execute "mysql-dbd" do
  command "/usr/local/bin/mysql-dbd"
  action :nothing
end

package "MySQL-shared-compat-advanced" do
  action :upgrade
end

package "MySQL-client-advanced" do
  action :upgrade
end

package "MySQL-server-advanced" do
  action :upgrade
end

package "MySQL-devel-advanced" do
  action :upgrade
end

template "/etc/my.cnf" do
  source "my.cnf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "mysql")
end

dbdapp = "DBD-mysql-4.022"
yumserver = search(:node, "recipes:altisource\\:\\:yumserver OR recipes:github\\:\\:yum-repo")
if yumserver.nil? || yumserver.empty?
  Chef::Log.warn("No yum repositories found.")
else
  yumserver = yumserver.first
  yumserver = yumserver["ipaddress"]
end
template "/usr/local/bin/mysql-dbd" do
  source "mysql-dbd.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  variables(
    :dbdapp => dbdapp,
    :yumserver => yumserver
  )
  notifies :run, resources(:execute => "mysql-dbd")
end

directory "/mysql" do
  owner "mysql"
  group "mysql"
  action :create
end

directory "/mysql/data" do
  owner "mysql"
  group "mysql"
  action :create
end

directory "/mysql/log" do
  owner "mysql"
  group "mysql"
  action :create
end

directory "/mysql/log/err" do
  owner "mysql"
  group "mysql"
  action :create
end

directory "/mysql/log/slow" do
  owner "mysql"
  group "mysql"
  action :create
end

directory "/mysql/log/general" do
  owner "mysql"
  group "mysql"
  action :create
end

directory "/mysql/tmp" do
  owner "mysql"
  group "mysql" 
  action :create 
end

directory "/mysql/innodb" do
  owner "mysql"
  group "mysql"
  action :create
end

link "/usr/lib64/libmysqlclient.so.16.0.0" do
  to "/usr/lib64/libmysqlclient.so" 
  owner "root"
  group "root"
end

service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable ]
end

