#
# Cookbook Name:: testlink
# Recipe:: default
#
# Copyright 2013, Altsource Labs
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::lamp"
include_recipe "sendmail"

template "/etc/php.ini" do
  owner "root"
  group "root"
  mode 0644
  source 'php.ini.erb'
  notifies :restart, resources(:service => "httpd"), :delayed
end

