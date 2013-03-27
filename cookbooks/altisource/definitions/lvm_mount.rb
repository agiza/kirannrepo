#
# Cookbook Name:: altisource
# Definition:: lvm_mount
#

define :lvm_mount do
  if node.attribute?("novolume")
    Chef::Log.info("No volume mount attribute is set.")
  else
    include_recipe "lvm::default"
    lvm_logical_volume "#{params[:name]}" do
      group "#{params[:group]}"
      size "100%VG"
      filesystem "ext4"
      mount_point "#{params[:mountpoint]}"
    end
  
end

end

