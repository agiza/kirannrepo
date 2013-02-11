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
    volumes.each do |volume|
      voldata = volume["#{volume}"].split("|")
      execute "#{volume}-mount" do
        command "/usr/local/bin/#{volume}-mount.sh"
        action :nothing
      end
      template "/usr/local/bin/#{volume}-mount.sh" do
        source "volgrp-create.erb"
        group  "root"
        owner  "root"
        mode   "0755"
        variables(
          :mount => voldata[0],
          :device => voldata[1]
        )
       # notifies :run, "execute[#{volume}-mount]", :delayed
      end
    end
  end
end
