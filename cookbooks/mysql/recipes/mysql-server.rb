#
# Cookbook Name:: mysql
# Recipe:: mysql-server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"

yum_package "mysql" do
  action :remove
end

yum_package "mysql-server" do
  action :remove
end

yum_package "mysql-devel" do
  action :remove
end

yum_package "mysql-libs" do
  action :remove
end

service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

package "MySQL-client-advanced" do
  action :upgrade
end

package "MySQL-server-advanced" do
  action :upgrade
end

package "MySQL-shared-compat-advanced" do
  action :upgrade
end

template "/etc/my.cnf" do
  source "my.cnf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "mysql")
end

package "cronie" do
  action :upgrade
end

package "cronie-anacron" do
  action :upgrade
end

package "crontabs" do
  action :upgrade
end

package "postfix" do
  action :upgrade
end

package "sysstat" do
  action :upgrade
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

service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

