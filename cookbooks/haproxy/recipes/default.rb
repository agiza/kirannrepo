#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "haproxy"

service "haproxy" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

package "haproxy" do
  action :install
  action :upgrade
end

rabbitservers = search(:node, "role:rabbitserver AND chef_environment:#{node.chef_environment}")
clusternodes = rabbitservers.collect { |rabbitserver| "rabbit@#{rabbitserver}" }.join(" ")
clusternodes = clusternodes.gsub!("node\[", "")
clusternodes = clusternodes.gsub!("\]", "")

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  group "haproxy"
  owner "haproxy"
  mode "0644"
  notifies :restart, resources(:service => "haproxy")
end

