#
# Cookbook Name:: testlink
# Recipe:: default
#
# Copyright 2013, Altsource Labs
#
# All rights reserved - Do Not Redistribute
#
#include_recipe "sendmail"
include_recipe "infrastructure::base"

template "/etc/rc.local" do
  owner "root"
  group "root"
  mode 0755
  source 'rc.local.erb'
end

