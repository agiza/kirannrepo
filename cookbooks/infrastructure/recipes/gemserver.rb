#
# Cookbook Name:: infrastructure
# Recipe:: gemserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

service "gemserver" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

proxyinfo = data_bag_item("infrastructure", "proxy")
if proxyinfo.nil? || proxyinfo.empty?
  Chef::Log.info("No services returned from search.")
else
  template "/etc/init.d/gemserver" do
    source "gemserver-init.erb"
    owner  "root"
    group  "root"
    mode   "0755"
    variables(
      :ipaddress => node[:ipaddress]
    )
    notifies :restart, resources(:service => "cntlmd")
  end
end

service "gemserver" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

