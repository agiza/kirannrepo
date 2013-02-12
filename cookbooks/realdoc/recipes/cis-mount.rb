#
# Cookbook Name:: realdoc
# Recipe:: cis-mount
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# cis-mount recipe requires three attributes.  cismount which is the mount point, cisusername which is the smb username to use for credentials and cispassword which is the password.  Failure to provide all three will result in an error.
if node.attribute?("novolume")
  Chef::Log.info("No volume mount attribute is set.")
else
  cismount = node[:cismount]
  if cismount.nil? || cismount.empty?
    Chef::Log.info("No CIS mounts found to mount.")
  else
    if node[:cisusername].nil? | node[:cisusername].empty? || node[:cispassword].nil? || node[:cispassword].empty?
      Chef::Log.info("No smbcredentials provided, this mount will not work properly.")
    else
      cisusername = node[:cisusername]
      cispassword = node[:cispassword]
      template "/root/.smbcredentials" do
        source "smbcredential.erb"
        owner  "root"
        group  "root"
        mode   "0640"
        variables(
          :cisusername => cisusername,
          :cispassword => cispassword
        )
      end
      execute "cis-mount" do
        command "/usr/local/bin/cis-mount.sh"
        action :nothing
      end
      template "/usr/local/bin/cis-mount.sh" do
        source "correspondence-create.erb"
        group  "root"
        owner  "root"
        mode   "0755"
        variables(
          :cismount => cismount
        )
        notifies :run, "execute[cis-mount]", :immediately
      end
    end
  end
end

