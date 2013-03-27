#
# Cookbook Name:: altisource
# Definition:: lvm_mount
#

define :lvm_mount do
  if node.attribute?("novolume")
    Chef::Log.info("No volume mount attribute is set.")
  else
    execute "pvcreate" do
      command "/sbin/pvcreate #{params[:device]}"
      #Chef::Log.info("Would execute pvcreate  #{params[:device]}")
      only_if "/sbin/pvdisplay #{params[:device]} 2>&1 | grep -q 'Failed to read physical volume'"
      action :run
    end
  
    execute "vgcreate" do
      command "/sbin/vgcreate #{params[:group]}"
      #Chef::Log.info("Would execute vgcreate #{params[:group]}")
      only_if "/sbin/vgdisplay #{params[:group]} 2>&1 | grep -q 'not found'"
      action :run
    end

    execute "lvcreate" do
      command "/sbin/lvcreate -l 100%VG #{params[:group]}"
      #Chef::Log.info("Would execute lvcreate -l 100%VG #{params[:group]}")
      not_if "/sbin/lvdisplay -c /dev/#{params[:group]}/#{params[:volume]}"
      action :run
    end

    execute "format" do
      command "/sbin/mkfs -t #{params[:filesystem]} -m 1 /dev/mapper/#{params[:group]}-#{params[:volume]}"
      #Chef::Log.info("Would execute mkfs -t #{params[:filesystem]} -m 1 /dev/mapper/#{params[:group]}-#{params[:volume]}")
      not_if "/sbin/blkid /dev/mapper/#{params[:group]}-#{params[:volume]} | grep \"TYPE=\"#{params[:filesystem]}\"\""
      action :run
    end  

    mount "#{params[:name]}" do
      device "/dev/mapper/#{params[:group]}-#{params[:volume]}"
      mount_point "#{params[:mountpoint]}"
      fstype "#{params[:filesystem]}"
      options "#{params[:options]}"
      action [:mount, :enable]
    end 
  end  
end

