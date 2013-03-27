#
# Cookbook Name:: altisource
# Definition:: lvm_mount
#

define :lvm_mount do
  if node.attribute?("novolume")
    Chef::Log.info("No volume mount attribute is set.")
  else
    include_recipe "lvm::default"
    lvm_volume_group "#{params[:group]}" do
      physical_volumes [ params[:device] ]
      lvm_logical_volume "#{params[:volume]}" do
        group "#{params[:group]}"
        size "100%VG"
        filesystem "ext4"
        mount_point :location => "#{params[:mountpoint]}", :options => "defaults"
      end
    end
  
end

end

