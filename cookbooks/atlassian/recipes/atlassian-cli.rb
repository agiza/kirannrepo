#
# Cookbook Name:: atlassian
# Recipe:: atlassian-cli
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

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

template "/opt/atlassian/cli/atlassian.sh" do
  source "atlassian.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

