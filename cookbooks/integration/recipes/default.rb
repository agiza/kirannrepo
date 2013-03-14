#
# Cookbook Name:: integration
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
begin
  applications =  data_bag_item("infrastructure", "applications")
  rescue Net::HTTPServerException
    raise "Unable to load applications data bag item from infrastructure data bag."
end
appnames = applications["appnames"]
# This looks for rabbitmq proxy attribute "ip/hostname:port" or finds the first instance itself.
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = []
  appnames["rabbitmq"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:shared").each do |worker|
      amqphost << worker
    end
  end
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No rabbitmq servers returned from search.") && amqphost = "No servers found."
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
end

# Set default attributes for use by recipes.
node.default.amqphost = amqphost
node.default.amqpport = amqpport

include_recipe "altisource::altitomcat"
