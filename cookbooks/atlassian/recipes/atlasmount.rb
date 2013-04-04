#
# Cookbook Name:: atlassian
# Recipe:: atlasmount
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

cloud_mount "var" do
  device "/dev/xvdc"
  mountpoint "/var/atlassian"
  fstype "ext4"
  options "defaults,nobootwait,comment=varatlas"
end

cloud_mount "opt" do
  device "/dev/xvdd"
  mountpoint "/opt/atlassian"
  fstype "ext4"
  options "defaults,nobootwait,comment=optatlas"
end

cloud_mount "mnt" do
  device "/dev/xvdb"
  mountpoint "/mnt"
  fstype "ext4"
  options "defaults,nobootwait,comment=cloudconfig"
end

cloud_mount "backup" do
  device "/dev/xvdh"
  mountpoint "/backup"
  fstype "ext4"
  options "defaults,nobootwait,comment=backup"
end

  
