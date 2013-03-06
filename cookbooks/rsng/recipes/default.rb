#
# Cookbook Name:: rsng
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::altitomcat"

if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.info("No rabbitmq servers returned from search.")
  else
    amqphostip = []
    amqphost.each do |amqphost|
      amqphostip << amqphost["ipaddress"]
    end
    amqphost = amqphostip.sort.first
    amqpport = "5672"
  end
end

if node.attribute?('rsngproxy')
  rsnghost = node[:rsngproxy].split(":")[0]
  rsngport = node[:rsngproxy].split(":")[1]
else
  rsnghost = search(:node, "rsngapp_version:* AND chef_environment:#{node.chef_environment}")
  if rsnghost.nil? || rsnghost.empty?
    Chef::Log.info("No rsng servers returned from search.")
  else
    rsnghostip = []
    rsnghost.each do |rsnghost|
      rsnghostip << rsnghost["ipaddress"]
    end
    rsnghost = rsnghostip.sort.first
    rsngport = "8080"
  end
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

node.default.rsnghost = rsnghost
node.default.rsngport = rsngport
node.default.amqphost = amqphost
node.default.amqpport = amqpport

