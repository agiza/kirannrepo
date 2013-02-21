#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# Create a service for rabbitmqadmin python script to allow for a notification run when upgrade occurs.
execute  "rabbitmqadmin" do
  command "if [ -f /etc/rabbitmq/rabbitmqadmin ]; then rm -f /etc/rabbitmq/rabbitmqadmin; fi; wget -O /etc/rabbitmq/rabbitmqadmin http://#{node[:ipaddress]}:15672/cli/rabbitmqadmin; chmod +x /etc/rabbitmq/rabbitmqadmin"
  action :nothing
end

include_recipe "altisource::altirepo"
include_recipe "altisource::epel-local"
include_recipe "infrastructure::selinux"

package "rabbitmq-server" do
  #provider Chef::Provider::Package::Yum
  action :upgrade
  notifies :run, resources(:execute => "rabbitmqadmin")
end

execute "rabbit-stomp" do
  command "rabbitmq-plugins enable rabbitmq_stomp"
  action :run
  not_if "grep rabbitmq_stomp /etc/rabbitmq/enabled_plugins"
end

execute "rabbit-management" do
  command "rabbitmq-plugins enable rabbitmq_management"
  action :run
  not_if "grep rabbitmq_management /etc/rabbitmq/enabled_plugins"
end


