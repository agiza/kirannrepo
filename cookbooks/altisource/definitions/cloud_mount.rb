#
# Cookbook Name:: altisource
# Definition:: cloud_mount
#

define :cloud_mount do
  if node.attribute?("nocloud")
    Chef::Log.info("No cloud mount attribute is set.")
  else
    directory "#{params[:mountpoint]}" do
      recursive true
      action :create
    end

    execute "format" do
      command "/sbin/mkfs -t #{params[:filesystem]} -m 1 #{params[:device]}"
      not_if "/sbin/blkid -o full -s TYPE #{params[:device]} | grep \"#{params[:filesystem]}\""
      action :run
    end  

    mount "#{params[:name]}" do
      device "#{params[:device]}"
      mount_point "#{params[:mountpoint]}"
      fstype "#{params[:filesystem]}"
      options "#{params[:options]}"
      action [:mount, :enable]
    end 
  end  
end

