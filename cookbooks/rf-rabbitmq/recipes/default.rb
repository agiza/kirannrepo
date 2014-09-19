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
include_recipe 'rabbitmq::cluster_management'


##Rules Management
##Be aware this stuff is hardcoded here
bash "declare queue, exchange and binding" do
  cwd "/tmp"
  code <<-EOH
              sudo wget http://rulesmgmt:rulesmgmt12@localhost:15672/cli/rabbitmqadmin
              sudo chmod +x rabbitmqadmin
              sudo cp -f rabbitmqadmin /usr/local/bin/rabbitmqadmin
              rabbitmqadmin -H localhost -u rulesmgmt -p rulesmgmt12 -V RulesPublishing declare queue name=publishQueue auto_delete=false durable=true
              rabbitmqadmin  -H localhost -u rulesmgmt -p rulesmgmt12 -V RulesPublishing declare exchange name=toRabbit type=direct
              rabbitmqadmin  -H localhost -u rulesmgmt -p rulesmgmt12 -V RulesPublishing declare binding source=toRabbit destination_type=queue destination=publishQueue routing_key=publishKey
  EOH
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

rabbitmq_policy "rulesmanagement.policy" do
  pattern "publishQueue"
  params ({"ha-mode"=>"all"})
  priority 1
  action :set
end
