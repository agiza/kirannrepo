#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitmqserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rabbitmq::default"

# This will attempt to determine if there is any node claiming to be the master, if not, this node will be delegated to be the master.
rabbitmaster = search(:node, "rabbitmq-master:*")
if rabbitmaster.nil? || rabbitmaster.empty?
  Chef::Log.warn("There is no rabbitmq master detected, this node will be delegated as master.")
  node.set['rabbitmq-master'] = true
else
  # If this is the master, trigger the rabbitmq master recipe.
  if node.attribute?('rabbitmq-master')
    include_recipe "rabbitmq::rabbitmaster"
  # If this is not the master, trigger the worker recipe.
  else
    include_recipe "rabbitmq::rabbitworker"
  end
end

