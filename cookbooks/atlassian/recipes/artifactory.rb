#
# Cookbook Name:: atlassian
# Recipe:: nexus
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/root/mount-storage.sh" do
  source "mount-storage-nexus.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

execute "mountopt" do
  command "/root/mount-storage.sh"
  creates "/storage/lost+found"
  action :run
end

template "/etc/init.d/artifactory" do
  source "artifactory-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/artifactory/default" do
  source "artifactory-default.erb"
  owner  "artifactory"
  group  "root"
  mode   "0755"
end

template "/etc/artifactory/jetty.xml" do
  source "artifactory-jetty.xml.erb"
  owner  "artifactory"
  group  "root"
  mode   "0755"
end

service "artifactory" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end

cron "backups" do
  minute "0"
  user   "root"
  command "rsync -av --delete /storage/ /backups/"
end

cron "config_back" do
  minute "5"
  user   "root"
  command "rsync -av --delete /etc/artifactory /backups/etc/"
end

