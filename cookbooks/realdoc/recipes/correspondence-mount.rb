#
# Cookbook Name:: realdoc
# Recipe:: correspondence-mount
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

corrmount = node[:corrmount]
if corrmount.nil? || corrmount.empty?
  Chef::Log.info("No correspondence mounts found to mount.")
else
  include_recipe "altisource::volume"
  netvolume_mount "volume_corr" do
    volumes = "#{node[:corrmount]}"
  end
end
