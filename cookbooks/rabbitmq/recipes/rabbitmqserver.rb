#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitmqserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rabbitmq::default"

# If this is the master, trigger the rabbitmq master recipe.
if node.attribute?('rabbitmq-master')
  include_recipe "rabbitmq::rabbitmaster"
# If this is not the master, trigger the worker recipe.
else
  include_recipe "rabbitmq::rabbitworker"
end

