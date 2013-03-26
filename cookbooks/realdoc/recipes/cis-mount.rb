#
# Cookbook Name:: realdoc
# Recipe:: cis-mount
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# cis-mount recipe requires three attributes.  cismount which is the mount point, cisusername which is the smb username to use for credentials and cispassword which is the password.  Failure to provide all three will result in an error.

unless node[:cisvolume].nil? || node[:cisvolume].empty?
  cisvolume = node[:cisvolume]
  include_recipe "altisource::volume"
  cifsvolume_mount "/opt/tomcat/files/cis" do
    device "#{cisvolume[:device]}"
    mount_point "#{cisvolume[:mountpoint]}"
    options "#{cisvolume[:options]}"
  end
else
  Chef::Log.info("No CIS Volumes found to mount.")
end

