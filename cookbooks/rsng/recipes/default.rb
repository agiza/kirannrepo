#
# Cookbook Name:: rsng
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
    raise "Problem loading application names from infrastructure data bag."
end

amqphost_search do 
end

rsnghost_search do 
end

# This looks for amqp vhost attribute or creates one if it is missing.
if node.attribute?('realservice_amqp_vhost')
  Chef::Log.info("Rabbitmq vhost attribute found.")
else
  amqpvhost = search(:node, "realservice_amqp_vhost:* AND chef_environment:#{node.chef_environment}")
  if amqpvhost.nil? || amqpvhost.empty?
    amqpenviron = "#{node[:chef_environment]}".downcase
    amqpvhost = "realservice#{amqpenviron}"
    node.default.realservice_amqp_vhost = amqpvhost
  end
end

