#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::volume"
#volume_mount "volume_mysql" do
#  volumes "sdb|data|u02/mysqldata1/data|defaults sdc|innodb|u02/mysqldata1/innodb|defaults sdd|mysqllog|u02/mysqldata/mysqllog|defaults sde|tmp|u02/mysqldata/tmp|defaults sdf|backup|u03/mysqldata|defaults"
#end

lvm_mount "data" do
  device "/dev/sdb"
  group  "data_vg"
  volume "lvol0"
  mountpoint "/u02/mysqldata1/data"
end

lvm_mount "innodb" do
  device "/dev/sdc"
  group  "innodb_vg"
  volume "lvol0"
  mountpoint "/u02/mysqldata1/innodb"
end

lvm_mount "mysqllog" do
  device "/dev/sdd"
  group  "mysqllog_vg"
  volume "lvol0"
  mountpoint "/u02/mysqldata/mysqllog"
end

lvm_mount "tmp" do
  device "/dev/sde"
  group  "tmp_vg"
  volume "lvol0"
  mountpoint "/u02/mysqldata/tmp"
end

lvm_mount "backup" do
  device "/dev/sdf"
  group  "backup_vg"
  volume "lvol0"
  mountpoint "/u02/mysqldata"
end

