#
# Cookbook Name:: atlas-server
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

template "/etc/init.d/nexus" do
  source "nexus-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "nexus" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end

cron "backups" do
  minute "0"
  user   "root"
  command "rsync -av --delete /storage/ /backups/"
end
