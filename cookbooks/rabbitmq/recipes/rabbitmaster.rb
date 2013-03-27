#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitmaster
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# Create execution to allow for notification to trigger run.
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
# Check for stress/performance environment as infrastructure may be separate there.
if node.attribute?('performance')
  environment = node[:chef_environment]
else
  environment = "shared"
end
%w{rabbitmqserver rabbitmaster}.each do |app|
  search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environment}").each do |worker|
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
#rabbitservers = rabbitservers.uniq.sort!

# This collects and converts the hostnames into the format for a cluster file.
rabbitservers = rabbitservers.collect { |entry| "\'rabbit@#{entry}\'"}.uniq.sort.join(",\ ")
# This grabs entries for the hosts file in case there is no local dns.
hostentries = []
%w{rabbitmqserver rabbitmaster}.each do |app|
  search(:node, "recipes:*\\:\\:#{app}").each do |worker|
    hostentries << worker
  end
end
#hosts = hostentries.uniq.sort

#Pull Core rabbit from databag
begin
  rabbitcore = data_bag_item("rabbitmq", "rabbitmq")
    rescue Net::HTTPServerException
      raise "Error trying to pull rabbitmq info from rabbitmq data bag."
end
# Join cluster
execute "cluster" do
  command "rabbitmqctl stop_app; rabbitmqctl join_cluster #{rabbitservers}; rabbitmqctl start_app"
  notif "rabbitmqctl cluster_status | grep rabbit@#{node[:hostname]}"
end

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  group 'root'
  owner 'root'
  mode '0644'
  variables(
     :rabbitnodes => rabbitservers
  )
  notifies :restart, resources(:service => "rabbitmq-server"), :immediately
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
  notifies :restart, resources(:service => "rabbitmq-server"), :immediately
end

# Pull all entries in data_bag rabbitmq to get a list of apps for looping.
begin
  rabbitapps = data_bag("rabbitmq")
    rescue Net::HTTPServerException
      raise "Error loading rabbitmq data bag."
end
# This defines the common service that creates the initial cluster.
execute "rabbit-config" do
  command "/etc/rabbitmq/rabbit-common.sh"
  action :nothing
  environment ({'HOME' => '/etc/rabbitmq'})
end

# This loops through all apps and defines a service to execute setup
rabbitapps.each do |app|
  unless "#{app}" == "rabbitmq"
    execute "#{app}-config" do
      command "/etc/rabbitmq/#{app}-rabbit.sh"
      action :nothing
      environment ({'HOME' => '/etc/rabbitmq'})
    end
  end
end

# Declare an array for a comprehensive list of all vhosts to be created.
vhost_names = []
# This loops through all application entries to create the actual script to setup application entries
rabbitapps.each do |app|
  unless "#{app}" == "rabbitmq"
    appvhosts = []
    appvhosts = search(:node, "#{app}_amqp_vhost:*").map {|n| n["#{app}_amqp_vhost"]}
    name_queue = data_bag_item("rabbitmq", app)
    if name_queue["vhosts"].nil? || name_queue["vhosts"].empty?
      Chef::Log.info("No additional vhosts to add for this app.")
    else
      name_queue["vhosts"].split(" ").each do |vhost|
        appvhosts << vhost
      end
    end
    appvhosts = appvhosts
    appvhosts.each do |vhost|
      vhost_names << vhost
    end
    appvhosts = appvhosts.collect {|vhost| "#{vhost}" }.sort.uniq.join(" ")
    template "/etc/rabbitmq/#{app}-rabbit.sh" do
      source "app_rabbit.erb"
      group "root"
      owner "root"
      mode '0755'
      variables(
        :queue_names  => name_queue['queues'],
        :exchange_names => name_queue['exchange'],
        :binding_names => name_queue['binding'],
        :vhost_names => appvhosts,
        :userstring => name_queue['user'],
        :adminuser => rabbitcore['adminuser']
      )
      notifies :run, "execute[#{app}-config]", :delayed
    end
  end
end

# Create a string of all vhost names to use for the comprehensive vhost collection.
vhost_names = vhost_names.sort.uniq.collect { |vhost| "#{vhost}" }.join(" ")

# Setup the core vhost entries first as these are common elements
# Vhost setup on cluster
vhost_names.split(" ").each do |vhost|
  rabbitmq_vhost "#{vhost}" do
    action :add
  end
end
# Admin account setup for all vhosts
rabbitmq_user "#{rabbitcore['adminuser'].split("|")[0]}" do
  password "#{rabbitcore['adminuser'].split("|")[1]}"
  action :add
end
vhost_names.split(" ").each do |vhost|
  rabbitmq_user "#{rabbitcore['adminuser'].split("|")[0]}" do
    vhost "#{vhost}"
    permissions ".* .* .*"
    action :set_permissions
  end
end

#template "/etc/rabbitmq/rabbit-common.sh" do
#  source "rabbit_common.erb"
#  group  "root"
#  owner  "root"
#  mode   "0755"
#  variables(
#    :rabbitnodes => rabbitservers,
#    :vhost_names => vhost_names,
#    :adminuser => rabbitcore['adminuser']
#  )
#  notifies :run, 'execute[rabbit-config]', :immediately
#end

rabbitmq_user "guest" do
  action :delete
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

