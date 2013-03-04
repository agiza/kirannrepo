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
  rfhost = search(:node, "recipes:realfoundation\\:\\:realfoundation OR role:realfoundation AND chef_environment:#{node.chef_environment}")
  if rfhost.nil? || rfhost.empty?
    Chef::Log.warn("No realfoundation servers found.") && rfhost = "No servers found."
  else
    rfhostip = []
    rfhost.each do |rfhost|
      rfhostip << rfhost["ipaddress"]
    end
    rfhost = rfhostip.sort.first
    rfport = "8080"
  end
end

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
    if rdochost.nil? || rdochost.empty?
    Chef::Log.warn("No realdoc servers returned from search.") && rdochost = "No servers found."
  else
    rdochostip = []
    rdochost.each do |rdochost|
      rdochostip << rdochost["ipaddress"]
    end
    rdochost = rdochostip.sort.first
    rdocport = "8080"
  end
end
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No rabbitmq servers returned from search.") && amqphost = "No servers found."
  else
    amqphostip = []
    amqphost.each do |amqphost|
      amqphostip << amqphost["ipaddress"]
    end
    amqphost = amqphostip.sort.first
    amqpport = "5672"
  end
end

node.default.rfhost = rfhost
node.default.rfport = rfport
node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.amqphost = amqphost
node.default.amqpport = amqpport

