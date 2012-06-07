#
# Cookbook Name:: rabbitmq-config
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altirepo"

app_name = "rabbitmq-server-config"
app_version = node[:rabbitmqconfig_version]

package "rabbitmq-server" do
  version "2.8.2-1"
  provider Chef::Provider::Package::Yum
  action :install
end

package "#{app_name}" do
  version "#{app_version}"
  provider Chef::Provider::Package::Yum
  action :install
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

rabbitservers = search(:node, "role:rabbitserver AND chef_environment:#{node.chef_environment}")  
rabbitnodes = rabbitservers.collect { |rabbitserver| "\'rabbit@#{rabbitserver}\'" }.join(", ")
rabbitnodes = rabbitnodes.gsub!("node\[", "")
rabbitnodes = rabbitnodes.gsub!("\]", "")
clusternodes = rabbitservers.collect { |rabbitserver| "rabbit@#{rabbitserver}" }.join(" ")
clusternodes = clusternodes.gsub!("node\[", "")
clusternodes = clusternodes.gsub!("\]", "")

#Build list of queues names for configuration
realtrans_queue = data_bag_item("queue_names", "realtrans")
realdoc_queue = data_bag_item("queue_names", "realdoc")
trans_exchange = data_bag_item("queue_names", "realtrans")
doc_exchange = data_bag_item("queue_names", "realdoc")

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  group 'root'
  owner 'root'
  mode '0644'
  variables(:rabbitnodes => rabbitnodes)
  notifies :restart, resources(:service => "rabbitmq-server")
end

execute "rabbit-config" do
  command "/etc/rabbitmq/rabbit-common.sh"
  action :nothing
  environment ({'HOME' => '/etc/rabbitmq'})
end

execute "realtrans-config" do
  command "/etc/rabbitmq/realtrans-rabbit.sh"
  action :nothing
  environment ({'HOME' => '/etc/rabbitmq'})
end

execute "realdoc-config" do
  command "/etc/rabbitmq/realdoc-rabbit.sh"
  action :nothing
  environment ({'HOME' => '/etc/rabbitmq'})
end

template "/etc/rabbitmq/rabbit-common.sh" do
  source "rabbit_common.erb"
  group  "root"
  owner  "root"
  mode   "0755"
  variables(
    :clusternodes => clusternodes
  )
  notifies :run, 'execute[rabbit-config]', :immediate
end

template "/etc/rabbitmq/realtrans-rabbit.sh" do
  source "realtrans_rabbit.erb"
  group "root"
  owner "root"
  mode '0755'
  variables(
    :queue_names  => realtrans_queue['queues'],
    :exchange_names => realtrans_queue['exchange']
  )
  notifies :run, 'execute[realtrans-config]', :immediately
end

template "/etc/rabbitmq/realdoc-rabbit.sh" do
  source "realdoc_rabbit.erb"
  group "root"
  owner "root"
  mode "0755"
  variables(
    :queue_names => realdoc_queue['queues'],
    :exchange_names => realdoc_queue['exchange']
  )
  notifies :run, 'execute[realdoc-config]', :immediately
end

