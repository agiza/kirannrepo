#
# Cookbook Name:: realfoundation
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if node.attribute?('rfproxy')
  rfhost = node[:rfproxy].split(":")[0]
  rfport = node[:rfproxy].split(":")[1]
else
  rfhost = search(:node, "recipes:realfoundation\\:\\:#{app_name} OR role:realfoundation AND chef_environment:#{node.chef_environment}")
  if rfhost.nil? || rfhost.empty?
    Chef::Log.warn("No services found.") && rfhost = "No servers found."
  else
    rfhost = rfhost.first
    rfhost = rfhost["ipaddress"]
    rfport = "8080"
  end
end

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
    if rdochost.nil? || rdochost.empty?
    Chef::Log.warn("No services returned from search.") && rdochost = "No servers found."
  else
    rdochost = rdochost.first
    rdochost = rdochost["ipaddress"]
    rdocport = "8080"
  end
end
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No services returned from search.") && amqphost = "No servers found."
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
end

node.default.rfhost = rfhost
node.default.rfport = rfport
node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.amqphost = amqphost
node.default.amqpport = amqpport

