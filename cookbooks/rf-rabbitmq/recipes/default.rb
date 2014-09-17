#
# Cookbook Name:: rf-rabbitmq
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Iptables rules for rabbitmq
include_recipe 'iptables::default'
iptables_rule 'port_rabbitmq'

#Iptables rule for ssh - just so I can connect to my vagrant container using vagrant ssh
#This should be removed
iptables_rule 'port_ssh'

#Setting host names
include_recipe 'rf-hosts::default'

# Install RabbitMQ in a clustered fashion
include_recipe 'rabbitmq-cluster::cluster_management'
