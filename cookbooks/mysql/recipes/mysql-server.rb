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

%w[MySQL-shared-compat-advanced MySQL-client-advanced MySQL-server-advanced MySQL-devel-advanced MySQL-test-advanced].each do |pkg|
  package pkg do
    action :upgrade
  end
end

link "/usr/lib64/libmysqlclient.so" do
  to "/usr/lib64/libmysqlclient.so.16.0.0"
end

#template "/etc/my.cnf" do
#  source "my.cnf.erb"
#  owner  "root"
#  group  "root"
#  mode   "0644"
#  notifies :restart, resources(:service => "mysql")
#end

dbdapp = "DBD-mysql-4.022"
yumserver_search do
end
yumserver = node[:yumserver]
template "/usr/local/bin/mysql-dbd" do
  source "mysql-dbd.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  variables(
    :dbdapp => dbdapp,
    :yumserver => yumserver
  )
  notifies :run, resources(:execute => "mysql-dbd"), :delayed
end

%w[/mysql /mysql/data /mysql/log /mysql/log/err /mysql/log/slow /mysql/log/general /mysql/tmp /mysql/innodb].each do |dir|
  directory dir do
    owner "mysql"
    group "mysql"
    action :create
  end
end

service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable ]
end

