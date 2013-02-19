#
# Cookbook Name:: integration
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
# This looks for rabbitmq proxy attribute "ip/hostname:port" or finds the first instance itself.
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No services returned from search.") && amqphost = "No servers found."
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
end

#altisource_network "#{amqphost}" do
#  port "#{amqpport}"
#  action :check
#  provider "altisource_netcheck"
#end

# Set default attributes for use by recipes.
node.default.amqphost = amqphost
node.default.amqpport = amqpport


