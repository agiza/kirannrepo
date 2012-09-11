#
# Cookbook Name:: atlas-server
# Recipe:: default
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

template "/etc/init.d/crowd" do
  source "crowd-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/fisheye" do
  source "fisheye-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/jira" do
  source "jira-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "confluence" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
end

service "jira" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
end

service "fisheye" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
end

service "crowd" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
end

template "/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties" do
  source "confluence-init.properties.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, resources(:service => "confluence")
end

template "/opt/atlassian/confluence/conf/server.xml" do
  source "confluence-server.xml.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, resources(:service => "confluence")
end

template "/opt/atlassian/jira/atlassian-jira/WEB-INF/classes/jira-application.properties" do
  source "jira-application.properties.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "jira")
end

template "/opt/atlassian/jira/conf/server.xml" do
  source "jira-server.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "jira")
end

template "/opt/atlassian/fisheye/bin/fisheyectl.sh" do
  source "fisheyectl.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
  notifies :restart, resources(:service => "fisheye")
end

template "/opt/atlassian/crowd/crowd.cfg.xml" do
  source "crowd.cfg.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "crowd")
end

template "/opt/atlassian/crowd/crowd-openidserver-webapp/WEB-INF/classes/crowd.properties" do
  source "crowd.properties.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "crowd")
end

template "/opt/atlassian/cli/user-add.sh" do
  source "user-add.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/opt/atlassian/cli/user-remove.sh" do
  source "user-remove.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
end

template "/etc/cron.daily/atlassian-backup" do
  source "atlassian-backup.erb"
  owner "root"
  group "root"
  mode  "0755"
end

template "/etc/cron.daily/confluence" do
  source "confluence-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "/etc/cron.daily/jira" do
  source "jira-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "/etc/cron.daily/fisheye" do
  source "fisheye-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "/opt/atlassian/cli/atlassian.sh" do
  source "atlassian.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "confluence" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :start
end

service "jira" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :start
end

service "fisheye" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :start
end

service "crowd" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :start
end

