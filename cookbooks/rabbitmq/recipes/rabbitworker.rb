#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitworker
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "guest-remove" do
  command "/etc/rabbitmq/rabbit-guest.sh"
  action :nothing
end

execute "rabbit-host" do
  command "/etc/rabbitmq/rabbit-host.sh"
  action :nothing
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

# This creates an array of all rabbitmq worker hostnames for the cluster config file.
rabbitservers = []
rabbitentries = []
if node.attribute?('performance')
  target_env = "#{node.chef_environment}"
else
  target_env = "shared"
end
%w{rabbitmqserver rabbitmaster rabbitworker}.each do |app| 
  search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{target_env}").each do |worker|
    rabbitentries << worker
  end
end
if rabbitentries.nil? || rabbitentries.empty?
  Chef::Log.warn("No rabbitservers found.") && rabbitentries = node[:hostname]
else
  rabbitentries.each do |rabbitentry|
    rabbitservers << rabbitentry[:hostname]
  end
end

# This collects and converts the hostnames into the format for a cluster file.
rabbitservers = rabbitservers.collect { |entry| "\'rabbit@#{entry}\'"}.sort.uniq.join(",\ ")
# This grabs entries for the hosts file in case there is no local dns.
hostentries = []
%w{rabbitmqserver rabbitmaster rabbitworker}.each do |app|
  search(:node, "recipes:*\\:\\:#{app}").each do |host|
    hostentries << host
  end
end
hostentries = hostentries.uniq
#Pull Core rabbit from databag
begin
  rabbitcore = data_bag_item("rabbitmq", "rabbitmq")
    rescue Net::HTTPServerException
      raise "Error loading rabbitmq information from rabbitmq data bag."
end

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  group 'root'
  owner 'root'
  mode '0644'
  variables(
     :rabbitnodes => rabbitservers
  )
  notifies :restart, resources(:service => "rabbitmq-server")
end

template "/etc/rabbitmq/rabbit-host.sh" do
  source "rabbit-host.sh.erb"
  group 'root'
  owner 'root'
  mode '0755'
  notifies :run, 'execute[rabbit-host]', :delayed
end

template "/etc/rabbitmq/hosts.txt" do
  source "hosts.txt.erb"
  group  "root"
  owner  "root"
  mode   "0644"
  variables(:hostentries => hostentries)
  notifies :run, 'execute[rabbit-host]', :delayed
end

execute "purgedb" do
  command "rm -rf /var/lib/rabbitmq/mnesia"
  action :nothing
end

template "/var/lib/rabbitmq/.erlang.cookie" do
  source "erlang.cookie.erb"
  owner  "rabbitmq"
  group  "rabbitmq"
  mode   "0600"
  variables( :cookie => rabbitcore['rabbit_cookie'] )
  notifies :stop, resources(:service => "rabbitmq-server"), :immediately
  notifies :run, resources(:execute => "purgedb"), :immediately
  notifies :start, resources(:service => "rabbitmq-server"), :immediately
end

rabbitmq_user "guest" do
  action :delete
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

