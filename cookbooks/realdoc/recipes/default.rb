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
include_recipe "iptables::default"

amqphost_search do
end

rdochost_search do
end

elastichost_search do
end

# This looks for amqp vhost attribute or creates one if it is missing.
if node.attribute?('realdoc_amqp_vhost')
  Chef::Log.info("Rabbitmq vhost attribute found.")
else
  amqpvhost = search(:node, "realdoc_amqp_vhost:* AND chef_environment:#{node.chef_environment}")
  if amqpvhost.nil? || amqpvhost.empty?
    amqpenviron = "#{node.chef_environment}".downcase
    amqpvhost = "realdoc#{amqpenviron}"
    node.default.realdoc_amqp_vhost = amqpvhost
  end
end

class Chef::Recipe
  include PrintReconAdapter
end

