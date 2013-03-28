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
  not_if "rabbitmqctl cluster_status | grep 'rabbit@#{node[:hostname]}'"
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
# For each application, we need to grab and create all users, exchanges, queues, and bindings.
rabbitapps.each do |app|
  # Collect All of the vhosts for any specific application
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
    # Collect all vhosts and create a string.
    appvhosts = appvhosts.collect {|vhost| "#{vhost}" }.sort.uniq.join(" ")
    # Define admin user and password
    admin_user = "#{rabbitcore['adminuser'].split("|")[0]}"
    admin_password = "#{rabbitcore['adminuser'].split("|")[1]}"
    # Split the string to allow for looping on each vhost.
    vhosts_list = appvhosts.split(" ")
    # Grab the normal queues for creation and split them for a loop.
    queues = name_queue['queues'].split(" ")
    # Grab the queues with options and split them for a loop, will separate the options later.
    queues_options = name_queue['queues_options'].split(" ")
    # Grab the normal exchanges and split them for a loop.
    exchanges = name_queue['exchanges'].split(" ")
    # Grab the exchanges with options and split them for a loop. will separate the options later.
    exchanges_options = name_queue['exchanges_options'].split(" ")
    # Grab the normal bindings, split them for looping.
    bindings = name_queue['bindings'].split(" ")
    # Grab the bindings with options and split them for loop, separate options later.
    bindings_options = name_queue['bindings_options'].split(" ")
    # Loop for all vhosts
    vhosts_lists.each do |vhost|
      # Exchanges creation
      exchanges.each do |exchange|
        rabbitmq_exchange "#{exchange}" do
          admin_user "#{admin_user}"
          admin_password "#{admin_password}"
          vhost "#{vhost}"
          source "null"
          type "null"
          destination "null"
          routingkey "null"
          option_key "null"
          option_value "null"
          action :add
        end
      end
      exchanges_options.each do |exchange_option|
        rabbitmq_exchange "#{exchange_option.split('|')[0]}" do
          admin_user "#{admin_user}"
          admin_password "#{admin_password}"
          vhost "#{vhost}"
          source "null"
          type "null"
          destination "null"
          routingkey "null"
          option_key "#{exchange_option.split('|')[1]}"
          option_value "#{exchange_option.split('|')[2]}"
          action :add
        end
      end
      # Queues creation
      queues.each do |queue|
        rabbitmq_queue "#{queue}" do
          admin_user "#{admin_user}"
          admin_password "#{admin_password}"
          vhost "#{vhost}"
          option_key "null"
          option_value "null"
          action :add
        end
      end
      queues_options.each do |queue_option|
        rabbitmq_queue "#{queue_option.split('|')[0]}" do
          admin_user "#{admin_user}"
          admin_password "#{admin_password}"
          vhost "#{vhost}"
          option_key "#{queue_option.split('|')[1]}"
          option_value "#{queue_option.split('|')[2]}"
          action :add_with_option
        end
      end
      # Bindings creation
      bindings.each do |binding|
        rabbitmq_exchange "#{binding.split('|')[0]}" do
          admin_user "#{admin_user}"
          admin_password "#{admin_password}"
          vhost "#{vhost}"
          source "#{binding.split('|')[1]}"
          type "#{binding.split('|')[2]}"
          destination "#{binding.split('|')[3]}"
          routingkey "#{binding.split('|')[4]}"
          option_key "null"
          option_value "null"
          action :set_binding
        end
      end
      bindings_options.each do |binding_option|
        rabbitmq_exchange "#{binding_option.split('|')[0]}" do
          admin_user "#{admin_user}"
          admin_password "#{admin_password}"
          vhost "#{vhost}"
          source "#{binding_option.split('|')[1]}"
          type "#{binding_option.split('|')[2]}"
          destination "#{binding_option.split('|')[3]}"
          routingkey "#{binding_option.split('|')[4]}"
          option_key "#{binding_option.split('|')[5]}"
          option_value "#{binding_option.split('|')[6]}"
          action :set_binding_option
        end
      end
    end
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
    action [:add, :setpolicy]
  end
end
# Admin account setup for all vhosts
rabbitmq_user "#{rabbitcore['adminuser'].split("|")[0]}" do
  password "#{rabbitcore['adminuser'].split("|")[1]}"
  tag "administrator"
  action [:add, :set_tags]
end
vhost_names.split(" ").each do |vhost|
  rabbitmq_user "#{rabbitcore['adminuser'].split("|")[0]}" do
    vhost "#{vhost}"
    permissions ".* .* .*"
    action :set_permissions
  end
end

rabbitmq_user "guest" do
  action :delete
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

