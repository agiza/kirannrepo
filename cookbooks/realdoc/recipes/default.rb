#
# Cookbook Name:: realdoc
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altitomcat"
include_recipe "mongodb::mongos"

begin
  appnames = data_bag_item("infrastructure", "applications")
  rescue Net::HTTPServerException
    raise "Problem loading applications names for search from infrastructure data bag."
end
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = []
  appnames["appnames"]["rabbitmq"].split(" ").each do |app|
  #%w{rabbitmqserver rabbitmaster rabbitworker}.each do |app|
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

# Test of search definition.
#include_recipe "altisource::default"
apptargets = "realdoc realdoc-server"
server_search "testdochost" do
  targetnames = "#{apptargets}"
  environment = "#{node.chef_environment}"
end
Chef::Log.info("node set was #{node[:testdochost]}.")

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = []
  appnames["appnames"]["realdoc"].split(" ").each do |app|
  #%w{realdoc realdoc-server}.each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
      rdochost << worker
    end
  end
  if rdochost.nil? || rdochost.empty?
    Chef::Log.warn("No realdoc servers returned from search.") && rdochost = "No servers found"
  else
    rdochostip = []
    rdochost.each do |rdochost|
      rdochostip << rdochost["ipaddress"]
    end
    rdochost = rdochostip.sort.first
    rdocport = "8080"
  end
end

if node.attribute?('elasticsearchproxy')
  elasticHost = node[:elasticsearchproxy]
else
  elasticHost = []
  appnames["appnames"]["elasticsearch"].split(" ").each do |app|
  #%w{elasticsearch}.each do |app|
    search(:node, "recipes:*h\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
      elasticHost << worker
    end
  end
  if elasticHost.nil? || elasticHost.empty?
    Chef::Log.warn("No elasticsearch servers returned from search.") && elasticHost = "No servers found."
  else
    elastichostip = []
    elasticHost.each do |elastichost|
      elastichostip << elastichost["ipaddress"]
    end
    elasticHost = elastichostip.sort.first
  end
end

# This looks for amqp vhost attribute or creates one if it is missing.
if node.attribute?('realdoc_amqp_vhost')
  Chef::Log.info("Rabbitmq vhost attribute found.")
else
  amqpvhost = search(:node, "realdoc_amqp_vhost:* AND chef_environment:#{node.chef_environment}")
  if amqpvhost.nil? || amqpvhost.empty?
    amqpenviron = "#{node[:chef_environment]}".downcase
    amqpvhost = "realdoc#{amqpenviron}"
    node.default.realdoc_amqp_vhost = amqpvhost
  end
end

# Set default node attributes for other recipes.
node.default.amqphost = amqphost
node.default.amqpport = amqpport
node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.elasticHost = elasticHost

