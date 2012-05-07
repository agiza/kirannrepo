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
queues = []
search(:queue_names, "queues") do |queue|
  # Set appname to id of the data bag item
  queues << queue
end

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  group 'root'
  owner 'root'
  mode '0644'
  variables(:rabbitnodes => rabbitnodes)
  notifies :restart, resources(:service => "rabbitmq-server")
end

execute "queue-config" do
  command "/etc/rabbitmq/realtrans-rabbit.sh"
  action :nothing
  environment ({'HOME' => '/etc/rabbitmq'})
end

template "/etc/rabbitmq/realtrans-rabbit.sh" do
  source "realtrans_rabbit.erb"
  group "root"
  owner "root"
  mode '0755'
  variables(
    :clusternodes => clusternodes,
    :queue_names  => queues
  )
  notifies :run, 'execute[queue-config]', :immediately
end

