#
# Cookbook Name:: altisource
# Recipe:: cloudmount
#

if node.attribute?("cloudmount")
  cloud_mount "#{node[:cloudmount][:name]}" do
    device "#{node[:cloudmount][:device]}"
    mountpoint "#{node[:cloudmount][:mountpoint]}"
    filesystem "#{node[:cloudmount][:filesystem]}"
    options "#{node[:cloudmount][:options]}"
  end
elsif not node.attribute?("cloudmount")
  Chef::Log.info("No cloud mount information present, attempting to mount default tomcat volume.")
  cloud_mount "tomcat" do
    device "/dev/xvdh"
    mountpoint "/opt/tomcat"
    filesystem "ext4"
    options "defaults"
  end
end
