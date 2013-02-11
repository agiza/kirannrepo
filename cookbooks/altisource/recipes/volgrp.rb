#
# Cookbook Name:: altisource
# Recipe:: volgrp
#

if node.attribute?("novolume")
  Chef::Log.info("No volume mount attribute is set.")
else
  volumes = node[:volumes]
  if volumes.nil? || volumes.empty?
    Chef::Log.info("No volumes found to mount.")
  else
    execute "volgrp-mount" do
      command "/usr/local/bin/volgrp-mount.sh"
      action :nothing
    end
    template "/usr/local/bin/volgrp-mount.sh" do
      source "volgrp-create.erb"
      group  "root"
      owner  "root"
      mode   "0755"
      variables(
        :voldata => volumes
      )
     # notifies :run, "execute[volgrp-mount]", :delayed
    end
  end
end

