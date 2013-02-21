#
# Cookbook Name:: realdoc
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No rabbitmq servers returned from search.") && amqphost = "No servers found."
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
end
if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
    if rdochost.nil? || rdochost.empty?
    Chef::Log.warn("No realdoc servers returned from search.") && rdochost = "No servers found"
  else
    rdochost = rdochost.first
    rdochost = rdochost["ipaddress"]
    rdocport = "8080"
  end
end

if node.attribute?('elasticsearchproxy')
  elasticHost = node[:elasticsearchproxy]
else
  elasticHost = search(:node, "recipes:elasticsearch\\:\\:elasticsearch AND chef_environment:#{node.chef_environment}")
  if elasticHost.nil? || elasticHost.empty?
    Chef::Log.warn("No elasticsearch servers returned from search.") && elasticHost = "No servers found."
  else
    elasticHost = elasticHost.first
    elasticHost = elasticHost["ipaddress"]
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

# This looks for mongo db attribute or creates one if it is missing.
if node.attribute?('mongodb_database')
  Chef::Log.info("Mongo DB database attribute found.")
else
  mongodbhost = search(:node, "mongodb_database:* AND chef_environment:#{node.chef_environment}")
  if mongodbhost.nil? || mongodbhost.empty?
    mongodbenviron = "#{node[:chef_environment]}".downcase
    mongodbhost = "realdoc#{mongodbenviron}"
    node.default.mongodb_database = mongodbhost
  end
end

# Set default node attributes for other recipes.
node.default.amqphost = amqphost
node.default.amqpport = amqpport
node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.elasticHost = elasticHost

