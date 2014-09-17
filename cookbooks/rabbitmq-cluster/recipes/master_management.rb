#
# Cookbook Name:: rabbitmq
# Recipe:: master_management
# Maintainer: cosmin.vasii@endava.com
# Includes the other recipes needed for the master node in a RabbitMQ cluster (creating users, vhosts, policies)

class Chef::Resource
  include Opscode::RabbitMQ
end

include_recipe 'rabbitmq-cluster::cluster_management'
include_recipe 'rabbitmq-cluster::plugin_management'
include_recipe 'rabbitmq-cluster::policy_management'
include_recipe 'rabbitmq-cluster::virtualhost_management'
include_recipe 'rabbitmq-cluster::user_management'
