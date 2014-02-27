#
# Cookbook Name:: atlassian
# Recipe:: jira
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init.d/jira" do
  source "jira-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "jira" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

template "/opt/atlassian/jira/atlassian-jira/WEB-INF/classes/jira-application.properties" do
  source "jira-application.properties.erb"
  owner  "jira"
  group  "jira"
  mode   "0644"
  notifies :restart, resources(:service => "jira")
end

template "/var/atlassian/application-data/jira/jira-config.properties" do
  source "jira-config.properties.erb"
  owner  "jira"
  group  "jira"
  mode   "0644"
  notifies :restart, resources(:service => "jira")
end

template "/opt/atlassian/jira/conf/server.xml" do
  source "jira-server.xml.erb"
  owner  "jira"
  group  "jira"
  mode   "0644"
  notifies :restart, resources(:service => "jira")
end

remote_file "/opt/atlassian/jira/lib/mysql-connector-java-5.1.22-bin.jar" do
  source "http://10.0.0.20/yum/common/mysql-connector-java-5.1.22-bin.jar"
  mode  "0644"
  owner "jira"
  group "jira"
  action :create_if_missing
end

template "/etc/cron.daily/jira" do
  source "jira-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "jira" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable,:start]
end


