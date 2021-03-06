#
# Cookbook Name:: altisource
# Definition:: cifsvolume_mount
#

define :cifsvolume_mount do

  if node.attribute?("novolume")
    Chef::Log.info("No volume mount attribute is set.")
  else
    mount "#{params[:name]}" do
      device "#{params[:device]}"
      mount_point "#{params[:mountpoint]}"
      fstype "cifs"
      options "#{params[:options]}"
      action [:mount, :enable]
    end
  end

end

