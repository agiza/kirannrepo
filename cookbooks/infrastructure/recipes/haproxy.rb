#
# Cookbook Name:: infrastructure
# Recipe:: haproxy
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "haproxy"
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy]
  amqpport = node[:amqpport]
else
  amqphost = {}
  search(:node, "role:rabbitserver") do |n|
    amqphost[n.ipaddress] = {}
  end
  amqphost = amqphost.first
  amqpport = "5672"
end

package "haproxy" do
  action :upgrade
end

service "haproxy" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

clusternodes = {}
search(:node, "role:rabbitserver") do |n|
  clusternodes[n.hostname] = {}
end


template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  group "haproxy"
  owner "haproxy"
  mode "0644"
  variables(
    :clusternodes => clusternodes,
    :amqpport => "#{amqpport}"
  )
  notifies :restart, resources(:service => "haproxy")
end

service "haproxy" do
  action [:enable, :start]
end

