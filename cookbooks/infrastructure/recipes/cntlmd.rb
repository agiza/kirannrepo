#
# Cookbook Name:: infrastructure
# Recipe:: cntlmd
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "cntlm" do
  action :upgrade
end

service "cntlmd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

proxyinfo = data_bag_item("infrastructure", "proxy")
template "/etc/cntlm.conf" do
  source "cntlm.conf.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  variables(
    :proxyinfo => proxyinfo
  )
  notifies :restart, resources(:service => "cntlmd")
end

service "cntlmd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

