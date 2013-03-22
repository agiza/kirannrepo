#
# Cookbook Name:: realdoc
# Recipe:: cis-mount
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# cis-mount recipe requires three attributes.  cismount which is the mount point, cisusername which is the smb username to use for credentials and cispassword which is the password.  Failure to provide all three will result in an error.
cismount = node[:cismount]
if cismount.nil? || cismount.empty?
  Chef::Log.info("No CIS mounts found to mount.")
else
  include_recipe "altisource::volume"
  netvolume_mount "volume_cis" do
    volume "#{node[:cismount]}"
  end
end

