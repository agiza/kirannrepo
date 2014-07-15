#
# Cookbook Name:: atlassian
# Recipe:: fisheye
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init.d/fisheye" do
  source "fisheye-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "fisheye" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

template "/opt/atlassian/fisheye/bin/fisheyectl.sh" do
  source "fisheyectl.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
  notifies :restart, resources(:service => "fisheye")
end

remote_file "/opt/atlassian/fisheye/lib/dbdrivers/mysql/mysql-connector-java-5.1.31-bin.jar" do
  source "http://10.0.0.20/yum/common/mysql-connector-java-5.1.31-bin.jar"
  mode  "0644"
  owner "root"
  group "root"
  action :create_if_missing
end

template "/etc/cron.daily/fisheye" do
  source "fisheye-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "fisheye" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable,:start]
end

