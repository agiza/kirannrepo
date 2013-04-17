#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"
include_recipe "altisource::epel-local"
include_recipe "infrastructure::selinux"

include_recipe "iptables::default"
iptables_rule "port_rabbitmq"

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

%w{rabbitmq_management rabbitmq_management_visualiser rabbitmq_stomp}.each do |plugin|
  rabbitmq_plugin "#{plugin}" do
    action :enable
  end
end

execute  "rabbitmqadmin" do
  command "if [ -f /etc/rabbitmq/rabbitmqadmin ]; then rm -f /etc/rabbitmq/rabbitmqadmin; fi; wget -O /etc/rabbitmq/rabbitmqadmin http://#{node[:ipaddress]}:15672/cli/rabbitmqadmin; chmod +x /etc/rabbitmq/rabbitmqadmin"
  action :nothing
end

link "/usr/bin/rabbitmqadmin" do
  to "/etc/rabbitmq/rabbitmqadmin"
  owner "root"
  group "root"
end

package "rabbitmq-server" do
  action :upgrade
  notifies :restart, resources(:service => "rabbitmq-server"), :immediately
  notifies :run, resources(:execute => "rabbitmqadmin")
end

execute  "rabbitmqadmin" do
  command "if [ -f /etc/rabbitmq/rabbitmqadmin ]; then rm -f /etc/rabbitmq/rabbitmqadmin; fi; wget -O /etc/rabbitmq/rabbitmqadmin http://#{node[:ipaddress]}:15672/cli/rabbitmqadmin; chmod +x /etc/rabbitmq/rabbitmqadmin"
  action :run
  only_if "file /etc/rabbitmq/rabbitmqadmin | grep 'python' == ''"
end

