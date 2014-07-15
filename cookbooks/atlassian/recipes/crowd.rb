#
# Cookbook Name:: atlassian
# Recipe:: crowd
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

#template "/etc/init.d/crowd" do
#  source "crowd-init.erb"
#  owner  "root"
#  group  "root"
#  mode   "0755"
#end

#service "crowd" do
#  supports :start => true, :stop => true, :restart => true, :status => true
#  action :nothing
#end

template "/opt/atlassian/crowd/crowd.cfg.xml" do
  source "crowd.cfg.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
#  notifies :restart, resources(:service => "crowd")
end

template "/opt/atlassian/crowd/crowd-openidserver-webapp/WEB-INF/classes/crowd.properties" do
  source "crowd.properties.erb"
  owner  "root"
  group  "root"
  mode   "0644"
#  notifies :restart, resources(:service => "crowd")
end

remote_file "/opt/atlassian/crowd/crowd-webapp/WEB-INF/lib/mysql-connector-java-5.1.22-bin.jar" do
  source "http://10.0.0.20/yum/common/mysql-connector-java-5.1.22-bin.jar"
  mode  "0644"
  owner "root"
  group "root"
  action :create_if_missing
end

#service "crowd" do
#  supports :start => true, :stop => true, :restart => true, :status => true
#  action :start
#end

