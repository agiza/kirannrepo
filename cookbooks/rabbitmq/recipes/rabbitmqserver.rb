#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitmqserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::altirepo"
include_recipe "altisource::epel-local"
include_recipe "infrastructure::selinux"

package "rabbitmq-server" do
  #provider Chef::Provider::Package::Yum
  action :upgrade
end

execute "rabbit-plugins" do
  command "rabbitmq-plugins enable rabbitmq_stomp; rabbitmq-plugins enable rabbitmq_management"
  action :run
end

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

# This creates an string collection of all rabbitmq servers for the cluster config file.
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

template "/etc/rabbitmq/rabbitmqadmin" do
  source "rabbitmqadmin.erb" 
  owner  "root"
  group  "root"
  mode   "0755"
end

# If this is the master rabbitmq server, we need to setup all vhosts/queues/exchanges and bindings.
if node.attribute?('rabbitmq-master')

# Setup empty array for comprehensive list of vhosts
  vhost_names = []
# Find all items in rabbitmq data bag and loop over them to build application data and vhosts
  rabbitapps = data_bag("rabbitmq")
  rabbitapps.each do |application_name|
    unless "#{application_name}" == "rabbitmq"
      name_queue = data_bag_item("rabbitmq", application_name)
      appvhosts = search(:node, "#{application_name}_amqp_vhost:*").map {|n| n["#{application_name}_amqp_vhost"]}
      appvhosts << name_queue["vhosts"]
      #appvhosts = appvhosts.collect { |vhost| "#{vhost}" }.sort.uniq.join(" ")
      vhost_names << appvhosts
    end
  end
  vhost_names = vhost_names.collect { |vhost| "#{vhost}" }.join("/ ").split(" ").sort.uniq.join(" ")

# This defines the common service that creates the initial cluster.
  execute "rabbit-config" do
    command "/etc/rabbitmq/rabbit-common.sh"
    action :nothing
    environment ({'HOME' => '/etc/rabbitmq'})
  end

# This loops through all apps and defines a service to execute setup
  rabbitapps.each do |application_name|
    unless "#{application_name}" == "rabbitmq"
      execute "#{application_name}-config" do
        command "/etc/rabbitmq/#{application_name}-rabbit.sh"
        action :nothing
        environment ({'HOME' => '/etc/rabbitmq'})
      end
    end
  end

# Setup the core vhost entries first as these are common elements
  template "/etc/rabbitmq/rabbit-common.sh" do
    source "rabbit_common.erb"
    group  "root"
    owner  "root"
    mode   "0755"
    variables(
      :rabbitnodes => rabbitservers,
      :vhost_names => vhost_names,
      :adminuser => rabbitcore['adminuser']
    )
    notifies :run, 'execute[rabbit-config]', :delayed
  end

# This loops through all application entries to create the actual script to setup application entries
  rabbitapps.each do |application_name|
    unless "#{application_name}" == "rabbitmq"
      name_queue = data_bag_item("rabbitmq", application_name)
      appvhosts = search(:node, "#{application_name}_amqp_vhost:*").map {|n| n["#{application_name}_amqp_vhost"]}
      appvhosts << name_queue['vhosts']
      appvhosts = appvhosts.collect {|vhost| "#{vhost}" }.join("/ ").split(" ").sort.uniq.join(" ")
      template "/etc/rabbitmq/#{application_name}-rabbit.sh" do
        source "app_rabbit.erb"
        group "root"
        owner "root"
        mode '0755'
        variables(
          :queue_names  => name_queue['queues'],
          :exchange_names => name_queue['exchange'],
          :binding_names => name_queue['binding'],
          #:vhost_names => name_queue['vhosts'],
          :vhost_names => appvhosts,
          :userstring => name_queue['user'],
          :adminuser => rabbitcore['adminuser']
        )
        notifies :run, "execute[#{application_name}-config]", :delayed
      end
    end
  end

# This is for the slave entries that only need to remove the default guest account.
else
  template "/etc/rabbitmq/rabbit-guest.sh" do
    source "rabbit_guest.erb"
    group  "root"
    owner  "root"
    mode   "0755"
    notifies :run, 'execute[guest-remove]', :delayed
  end
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end
