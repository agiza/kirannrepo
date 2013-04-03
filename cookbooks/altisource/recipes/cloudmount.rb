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
else
  Chef::Log.info("No cloud mount information set.")
end

