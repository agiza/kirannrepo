#
# Cookbook Name:: infrastructure
# Recipe:: lamp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "lamp"


# JSM: install/upgrade basic lamp server packages
yum_package "httpd" do
  action :upgrade
end
yum_package "php" do
  action :upgrade
end
yum_package "php-mysql" do
  action :upgrade
end
yum_package "MySQL-server-advanced" do
  action :upgrade
end
yum_package "MySQL-client-advanced" do
  action :upgrade
end


# JSM: start up apache by default
service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end
service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

