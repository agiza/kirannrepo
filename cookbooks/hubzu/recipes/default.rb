#
# Cookbook Name:: hubzu
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::altitomcat"

hzhost_search do 
end

amqphost_search do 
end

rdochost_search do
end

# This looks for amqp vhost attribute or creates one if it is missing.
if node.attribute?('hubzu_amqp_vhost')
  Chef::Log.info("Rabbitmq vhost attribute found.")
else
  amqpvhost = search(:node, "hubzu_amqp_vhost:* AND chef_environment:#{node.chef_environment}")
  if amqpvhost.nil? || amqpvhost.empty?
    amqpenviron = "#{node[:chef_environment]}".downcase
    amqpvhost = "hubzu#{amqpenviron}"
    node.default.hubzu_amqp_vhost = amqpvhost
  end
end

