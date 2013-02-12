#
# Cookbook Name:: realdoc
# Recipe:: correspondence-mount
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if node.attribute?("novolume")
  Chef::Log.info("No volume mount attribute is set.")
else
  corrmount = node[:corrmount]
  if corrmount.nil? || corrmount.empty?
    Chef::Log.info("No correspondence mounts found to mount.")
  else
    execute "corr-mount" do
      command "/usr/local/bin/corr-mount.sh"
      action :nothing
    end
    template "/usr/local/bin/corr-mount.sh" do
      source "correspondence-create.erb"
      group  "root"
      owner  "root"
      mode   "0755"
      variables(
        :corrmount => corrmount
      )
      notifies :run, "execute[corr-mount]", :immediately
    end
  end
end

