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
 amqpport = node[:amqpproxy].split(":")[1]
else
 amqpport = "5672"
end

if node.attribute?('stompproxy')
 stompport = node[:stompproxy].split(":")[1]
else
 stompport = "61613"
end

# Check for stress/performance environment as infrastructure may be separate there.
if node.attribute?('performance')
  environment = node[:chef_environment]
else
  environment = "shared"
end
clusternodes = []
rabbitnodes = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:#{environment}")
if rabbitnodes.nil? || rabbitnodes.empty?
  Chef::Log.warn("Unable to find any rabbitservers in the infrastructure.")
else
  rabbitnodes.each do |worker|
    clusternodes << worker["ipaddress"]
  end
  clusternodes = clusternodes.sort.uniq
  template "/etc/haproxy/haproxy.cfg" do
    source "rabbitproxy.cfg.erb"
    group "haproxy"
    owner "haproxy"
    mode "0644"
    variables(
      :clusternodes => clusternodes,
      :amqpport => amqpport,
      :stompport => stompport
    )
    notifies :restart, resources(:service => "haproxy")
  end
end

