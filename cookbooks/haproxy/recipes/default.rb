#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "haproxy"

package "haproxy" do
  action :upgrade
end

service "haproxy" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

clusternodes = []
rabbitservers = search(:node, "role:rabbitserver AND chef_environment:#{node.chef_environment}")
clusternodes = rabbitservers.collect { |rabbitserver| "rabbitserver" }.join(" ")
clusternodes = clusternodes.gsub!("node\[", "")
clusternodes = clusternodes.gsub!("\]", "")
clusternodes = clusternodes.gsub!(".altidev.com", "")

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  group "haproxy"
  owner "haproxy"
  mode "0644"
  variables(:clusternodes => clusternodes)
  notifies :restart, resources(:service => "haproxy")
end

