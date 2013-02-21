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
if node.attribute?('performance')
  rabbitentries = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:#{node.chef_environment}")
  if rabbitentries.nil? || rabbitentries.empty?
    Chef::Log.warn("No rabbitservers found.") && rabbitentries = node[:hostname]
  else
    rabbitentries.each do |rabbitentry|
      rabbitservers << rabbitentry[:hostname]
    end
  end
else
  rabbitentries = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if rabbitentries.nil? || rabbitentries.empty?
    Chef::Log.warn("No rabbitservers found.") && rabbitentries = node[:hostname]
  else
    rabbitentries.each do |rabbitentry|
      rabbitservers << rabbitentry[:hostname]
    end
  end
end

# This collects and converts the hostnames into the format for a cluster file.
rabbitservers = rabbitservers.collect { |entry| "\'rabbit@#{entry}\'"}.sort.join(",\ ")
# This grabs entries for the hosts file in case there is no local dns.
hostentries = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver")

#Pull Core rabbit from databag
rabbitcore = data_bag_item("rabbitmq", "rabbitmq")
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

template "/var/lib/rabbitmq/.erlang.cookie" do
  source "erlang.cookie.erb"
  owner  "rabbitmq"
  group  "rabbitmq"
  mode   "0600"
  variables( :cookie => rabbitcore['rabbit_cookie'] )
  notifies :restart, resources(:service => "rabbitmq-server")
end

# This is for the slave entries that only need to remove the default guest account.
template "/etc/rabbitmq/rabbit-guest.sh" do
  source "rabbit_guest.erb"
  group  "root"
  owner  "root"
  mode   "0755"
  notifies :run, 'execute[guest-remove]', :delayed
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

