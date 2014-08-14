#
# Cookbook Name:: ru-mongodb-srv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

%w[ /data /data/db].each do |path|
directory path do
    owner "root"
    group "root"
    mode  00777
  end
end


execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvdj"
   # only if it's not mounted already
     not_if "grep -qs /dev/xvdj /proc/mounts"
end

mount "/data/db" do
  device "/dev/xvdj"
  fstype "ext4"
  options "rw"
  action [:mount,:enable]
end



include_recipe "java"
include_recipe "mongodb"
include_recipe "iptables::disabled"
