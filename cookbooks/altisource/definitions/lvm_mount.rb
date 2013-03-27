#
# Cookbook Name:: altisource
# Definition:: lvm_mount
#

define :lvm_mount do
  if node.attribute?("novolume")
    Chef::Log.info("No volume mount attribute is set.")
  else
    include_recipe "lvm::default"

    execute "pvcreate" do
      command "pvcreate #{params[:device]}"
      only_if "pvdisplay #{params[:device]} 2>&1 | grep -q 'Failed to read physical volume'"
      action :nothing
    end
  
    execute "vgcreate" do
      command "vgcreate #{params[:group]}"
      only_if "lvdisplay #{params[:group]} 2>&1 | grep -q 'not found'"
      action :nothing
    end

    execute "lvcreate" do
      command "lvcreate -l 100%VG #{params[:group]}"
      not_if "lvdisplay -c /dev/#{params[:group]}/#{params[:volume]}"
      action :nothing
    end

    execute "format" do
      command "mkfs -t #{params[:filesystem]} -m 1 /dev/mapper/#{params[:group]}-#{params[:volume]}"
      not_if "blkid #{params[:device]} 2>&1 | grep -q #{params[:filesystem]}"
      action :nothing
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

