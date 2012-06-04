#
# Cookbook Name:: bamboo-server
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

service "bamboo" do
  supports :stop => true, :start => true, :restart => true, :statue => true
  action :enable
  action :start
end

directory "/home/bamboo/.ssh" do
  owner "bamboo"
  group "bamboo"
  action :create
end

directory "/home/bamboo/bin" do
  owner "bamboo"
  group "bamboo"
  action :create
end

template "/opt/atlassian/bamboo/bamboo.cfg.xml" do
  source "bamboo.cfg.xml.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

template "/opt/atlassian/bamboo/bamboo-mail.cfg.xml" do
  source "bamboo-mail.cfg.xml.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

template "/etc/init.d/bamboo" do
  source "bamboo.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :restart, resources(:service => "bamboo")
end

template "/opt/atlassian/bamboo/webapp/WEB-INF/classes/bamboo-init.properties" do
  source "bamboo-init.properties.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

template "/etc/cron.hourly/data-bak.sh" do
  source "data-bak.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/opt/atlassian/bamboo/conf/wrapper.conf" do
  source "wrapper.conf.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

link "/opt/atlassian/bamboo/artifacts" do
  to "/mnt/bamboo_data/artifacts"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/rpmbuild" do
  to "/mnt/bamboo_data/rpmbuild"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/.m2" do
  to "/mnt/bamboo_data/.m2"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/plugins" do
  to "/mnt/bamboo_data/plugins"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/webapp/WEB-INF/lib/hung-build-killer-2.1.jar" do
  to "/mnt/bamboo_data/plugins/hung-build-killer-2.1.jar"
  owner "bamboo"
  group "bamboo"
end

template "/home/bamboo/bin/bamboo-git-tag" do
  source "bamboo-git-tag.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0755"
end

template "/home/bamboo/bin/chef-run.sh" do
  source "chef-run.sh.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0755"
end

template "/home/bamboo/bin/tomcat-command-rhel.sh" do
  source "tomcat-command-rhel.sh.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0755"
end

template "/home/bamboo/bin/tomcat-command.sh" do
  source "tomcat-command.sh.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
end

template "/home/bamboo/bin/rpm-package" do
  source "rpm-package.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
end

