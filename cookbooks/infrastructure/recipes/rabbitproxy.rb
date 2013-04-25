#
# Cookbook Name:: infrastructure
# Recipe:: rabbitproxy
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "infrastructure::haproxy"
include_recipe "iptables::default"
iptables_rule  "port_rabbitproxy"

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
%w{rabbitmqserver rabbitmaster rabbitworker}.each do |app|
  search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environment}").each do |worker|
    clusternodes << worker["ipaddress"]
  end
end
if clusternodes.nil? || clusternodes.empty?
  Chef::Log.warn("Unable to find any rabbitservers in the infrastructure.")
else
  workernodes = clusternodes.uniq.sort
  template "/etc/haproxy/haproxy.cfg" do
    source "rabbitproxy.cfg.erb"
    group "haproxy"
    owner "haproxy"
    mode "0644"
    variables(
      :clusternodes => workernodes,
      :amqpport => amqpport,
      :stompport => stompport
    )
    notifies :restart, resources(:service => "haproxy")
  end
end

