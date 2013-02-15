#
# Cookbook Name:: hubzu
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if node.attribute?('hzproxy')
  hzhost = node[:hzproxy].split(":")[0]
  hzport = node[:hzproxy].split(":")[1]
else
  hzhost = search(:node, "recipes:hubzu\\:\\:hubzu OR role:hubzu AND chef_environment:#{node.chef_environment}")
  if hzhost.nil? || hzhost.empty?
    Chef::Log.warn("No services found.") && hzhost = "No servers found."
  else
    hzhost = hzhost.first
    hzhost = hzhost["ipaddress"]
    hzport = "8080"
  end
end

if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.info("No services returned from search.")
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
end

node.default.hzhost = hzhost
node.default.hzport = hzport
node.default.amqphost = amqphost
node.default.amqpport = amqpport

