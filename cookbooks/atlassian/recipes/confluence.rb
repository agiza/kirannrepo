#
# Cookbook Name:: atlassian
# Recipe:: confluence
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init.d/confluence" do
  source "confluence-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "confluence" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

template "/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties" do
  source "confluence-init.properties.erb"
  owner "confluence"
  group "confluence"
  mode  "0644"
  notifies :restart, resources(:service => "confluence")
end

template "/opt/atlassian/confluence/conf/server.xml" do
  source "confluence-server.xml.erb"
  owner "confluence"
  group "confluence"
  mode  "0644"
  notifies :restart, resources(:service => "confluence")
end

remote_file "/opt/atlassian/confluence/confluence/WEB-INF/lib/mysql-connector-java-5.1.22-bin.jar" do
  source "http://10.0.0.20/yum/common/mysql-connector-java-5.1.22-bin.jar"
  mode  "0644"
  owner "confluence"
  group "confluence"
  action :create_if_missing
end

template "/etc/cron.daily/confluence" do
  source "confluence-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "confluence" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable,:start]
end

