#
# Cookbook Name:: altisource
# Recipe:: volume
#

execute "volume-mount" do
  command "/usr/local/bin/volgrp-mount.sh"
  action :nothing
end

