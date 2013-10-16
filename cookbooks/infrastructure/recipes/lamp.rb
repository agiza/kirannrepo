#
# Cookbook Name:: infrastructure
# Recipe:: lamp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "lamp"

# JSM: upgrade all packages on every Chef client run
execute "yum-update-y" do
  command "yum update -y"
  ignore_failure true
  action :run
end
execute "yum-upgrade-y" do
  command "yum upgrade -y"
  ignore_failure true
  action :run
end
execute "rc-local-chef-client" do
  command "echo chef-client > /etc/rc.local"
  ignore_failure true
  action :run
end

# JSM: install base set of packages if not installed already
yum_package "telnet" do
  action :install
end
yum_package "lynx" do
  action :install
end
yum_package "traceroute" do
  action :install
end
yum_package "httpd" do
  action :install
end
yum_package "php" do
  action :install
end
yum_package "php-mysql" do
  action :install
end
yum_package "MySQL-server-advanced" do
  action :install
end
yum_package "MySQL-client-advanced" do
  action :install
end


# JSM: start up apache by default
service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

service "httpd" do
  action [:enable, :start]
end

