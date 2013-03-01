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
      notifies :run, "execute[volgrp-mount]", :immediately
    end
    volumes = volumes.split(" ")
    volumes.each do |volume|
      disk = volume.split("|")[0]
      device = "/dev/#{disk}"
      vol = volume.split("|")[1]
      volgrp = "#{vol}_vg"
      mountpoint = volume.split("|")[2]
      mount = "/#{mountpoint}"
      options = volume.split("|")[3]
      fulldevice = "/dev/mapper/#{volgrp}-lvol0"

      execute "pvcreate" do
        command "pvcreate #{device}"
        action :nothing
        not_if "test -f #{device}"
      end

      execute "vgcreate" do
        command "vgcreate #{volgrp} #{device}"
        action :nothing
      end

      execute "lvcreate" do
        command "lvcreate -l 100%VG #{volgrp}"
        action :nothing
      end

      execute "formatdisk" do
        command "mkfs -t #{type} -m 1 #{fulldevice}"
        action :nothing
      end

      mount "volume" do
        device "#{device}"
        fstype "#{type}"
        options "#{options}"
        mount_point "#{mount}"
        dump "0"
        pass "0"
        #action [:mount, :enable]
        action [:nothing]
      end
    end
  end
end

