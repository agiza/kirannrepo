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

include_recipe "altisource::volume"
if node.attribute["rabbitmq_volume"]
  lvm_mount "rabbitmq" do
    device "#{node[:rabbitmq_volume][:device]}"
    group  "#{node[:rabbitmq_volume][:group]}"
    volume "#{node[:rabbitmq_volume][:volume]}"
    filesystem "#{node[:rabbitmq_volume][:filesystem]}"
    options "#{node[:rabbitmq_volume][:defaults]}"
    mountpoint "#{node[:rabbitmq_volume][:mountpoint]}"
  end
else
  lvm_mount "rabbitmq" do
    device "/dev/sdb"
    group  "rabbit_vg"
    volume "lvol0"
    filesystem "ext4"
    options "defaults"
    mountpoint "/rabbit"
  end
end
%w{/rabbit/rabbitmq /rabbit/log}.each do |dir|
  directory "#{dir}" do
    action :create
    recursive true
  end
end

link "/var/lib/rabbitmq" do
  to "/rabbit/rabbitmq"
end
link "/var/log/rabbitmq" do
  to "/rabbit/log"
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

execute  "rabbitmqadmin" do
  command "if [ -f /etc/rabbitmq/rabbitmqadmin ]; then rm -f /etc/rabbitmq/rabbitmqadmin; fi; wget -O /etc/rabbitmq/rabbitmqadmin http://#{node[:ipaddress]}:15672/cli/rabbitmqadmin; chmod +x /etc/rabbitmq/rabbitmqadmin"
  action :nothing
end

package "rabbitmq-server" do
  action :upgrade
  notifies :restart, resources(:service => "rabbitmq-server"), :immediately
  notifies :run, resources(:execute => "rabbitmqadmin")
end

%w{rabbitmq_management rabbitmq_management_visualiser rabbitmq_stomp}.each do |plugin|
  rabbitmq_plugin "#{plugin}" do
    action :enable
  end
end

link "/usr/bin/rabbitmqadmin" do
  to "/etc/rabbitmq/rabbitmqadmin"
  owner "root"
  group "root"
end

execute  "rabbitmqadmin" do
  command "if [ -f /etc/rabbitmq/rabbitmqadmin ]; then rm -f /etc/rabbitmq/rabbitmqadmin; fi; wget -O /etc/rabbitmq/rabbitmqadmin http://#{node[:ipaddress]}:15672/cli/rabbitmqadmin; chmod +x /etc/rabbitmq/rabbitmqadmin"
  action :run
  only_if "file /etc/rabbitmq/rabbitmqadmin | grep 'python' == ''"
end

