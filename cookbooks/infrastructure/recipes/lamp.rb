#
# Cookbook Name:: infrastructure
# Recipe:: lamp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "lamp"

# JSM: install base set of packages if not installed already
#
#

["telnet = 1.9", .... ].each do |pkg|
  package pkg do
    action :upgrade
  end
end

%w{telnet lynx traceroute httpd php php-mysql MySQL-server-advanced MySQL-client-advanced} do |pkg|
  package pkg do
    action :upgrade
  end
end

yum_package "telnet" do
  action :upgrade
end
yum_package "lynx" do
  action :upgrade
end
yum_package "traceroute" do
  action :upgrade
end
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
  action :nothing
end
service "mysql" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end


service "httpd" do
  action [:enable, :start]
end
service "mysql" do
  action [:enable, :start]
end

