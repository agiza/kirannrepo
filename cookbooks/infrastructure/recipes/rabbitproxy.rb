#
# Cookbook Name:: infrastructure
# Recipe:: rabbitproxy
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::haproxy"

if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = {}
  search(:node, "role:rabbitserver") do |n|
    amqphost[n.ipaddress] = {}
  end
  amqphost = amqphost.first
  amqpport = "5672"
end

if node.attribute?('stompproxy')
  stomphost = node[:stompproxy].split(":")[0]
  stompport = node[:stompproxy].split(":")[1]
else
  stomphost = {}
  search(:node, "role:rabbitserver") do |n|
    stomphost[n.ipaddress] = {}
  end
  stomphost = stomphost.first
  stompport = "61613"
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
  clusternodes[n.ipaddress] = {}
end
if clusternodes.nil? || clusternodes.empty?
  Chef::Log.info("No services returned from search.")
else
  template "/etc/haproxy/haproxy.cfg" do
    source "rabbitproxy.cfg.erb"
    group "haproxy"
    owner "haproxy"
    mode "0644"
    variables(
      :clusternodes => clusternodes,
      :amqpport => "#{amqpport}",
      :stompport => "#{stompport}"
    )
    notifies :restart, resources(:service => "haproxy")
  end
end

