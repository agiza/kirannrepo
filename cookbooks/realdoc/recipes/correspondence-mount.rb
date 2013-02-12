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
  corrmount = data_bag_item("infrastructure", "correspondence")
  if corrmount.nil? || corrmount.empty?
    Chef::Log.info("No correspondence mounts found to mount.")
  else
    execute "correspondence-mount" do
      command "/usr/local/bin/correspondence-mount.sh"
      action :nothing
    end
    template "/usr/local/bin/correspondence-mount.sh" do
      source "correspondence-create.erb"
      group  "root"
      owner  "root"
      mode   "0755"
      variables(
        :corrmount => corrmount["mount"]
      )
      notifies :run, "execute[correspondence-mount]", :immediately
    end
  end
end

