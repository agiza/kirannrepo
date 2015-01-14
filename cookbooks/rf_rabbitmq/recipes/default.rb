#
# Cookbook Name:: rf_rabbitmq
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

#Iptables rules for rabbitmq
include_recipe 'iptables::default'
iptables_rule 'port_rabbitmq'
iptables_rule 'port_ssh'

#Setting host names
include_recipe 'rf_rabbitmq::add_aliases'

# Install RabbitMQ in a clustered fashion
include_recipe 'rabbitmq::default'
include_recipe 'rf_rabbitmq::cluster_discovery'
