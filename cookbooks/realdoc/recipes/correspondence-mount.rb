#
# Cookbook Name:: realdoc
# Recipe:: correspondence-mount
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

unless node[:corrmount].nil? || node[:corrmount].empty?
  corrmount = node[:corrmount]
  include_recipe "altisource::volume"
  netvolume_mount "volume_corr" do
    volumes = "#{node[:corrmount]}"
  end
else
  Chef::Log.info("No correspondence mounts found to mount.")
end

unless node[:corrvolume].nil? || node[:corrvolume].empty?
  corrvolume = node[:corrvolume]
  include_recipe "altisource::volume"
  nfsvolume_mount "volume_corr" do
    device "#{corrvolume[:device]}"
    mount_point "#{corrvolume[:mountpoint]}"
    options "#{corrvolume[:options]}"
    action [:mount, :enable]
  end
else
  Chef::Log.info("No Correspondence volumes found to mount.")
end

