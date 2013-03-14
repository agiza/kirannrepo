#
# Cookbook Name:: realfoundation
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altitomcat"
begin
  appnames = data_bag_item("infrastructure", "applications")
  rescue Net::HTTPServerException
    raise "Trouble loading application names for search from infrastructure data bag."
end
if node.attribute?('rfproxy')
  rfhost = node[:rfproxy].split(":")[0]
  rfport = node[:rfproxy].split(":")[1]
else
  rfhost = search(:node, "realfoundation_version:* AND chef_environment:#{node.chef_environment}")
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
  rdochost = []
  appnames["appnames"]["realdoc"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
      rdochost << worker
    end
  end
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
  amqphost = []
  appnames["appnames"]["rabbitmq"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:shared").each do |worker|
      amqphost << worker
    end
  end
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

