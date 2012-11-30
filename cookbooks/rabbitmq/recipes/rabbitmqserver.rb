#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitmqserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::altirepo"
include_recipe "infrastructure::selinux"

app_name = "rabbitmq-server-config"

package "rabbitmq-server" do
  provider Chef::Provider::Package::Yum
  action :upgrade
end

package "#{app_name}" do
  provider Chef::Provider::Package::Yum
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

rabbitservers = search(:node, "role:rabbitserver").collect { |rabbitserver| "\'rabbit@#{rabbitserver}\'" }.join(", ").gsub!("node\[", "").gsub!("\]", "").gsub!(".#{node[:domain]}","")
hostentries = search(:node, "role:rabbitserver")

# Setup empty array for comprehensive list of vhosts
vhost_names = []
# Find all items in rabbitmq data bag and loop over them to build application data and vhosts
rabbitapps = data_bag("rabbitmq")
rabbitapps.each do |application_name|
  unless "#{app_name}" == "rabbitmq"
    name_queue = data_bag_item("rabbitmq", application_name)
    applicationvhost = "#{application_name}_amqp_vhost"
    vhost_names << name_queue["vhosts"]
    appvhosts = {}
    search(:node, "applicationvhost:*") do |n|
      target = "#{n[0][:applicationvhost]}"
      appvhosts << target
    end
    appvhosts = appvhosts.collect { |vhost| "#{vhost}" }.join(" ").gsub!("/", "").sort.uniq.split(" ")
    vhost_names << appvhosts
  end
end

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
  notifies :run, 'execute[rabbit-host]', :immediately
end

template "/etc/rabbitmq/hosts.txt" do
  source "hosts.txt.erb"
  group  "root"
  owner  "root"
  mode   "0644"
  variables(:hostentries => hostentries)
  notifies :run, 'execute[rabbit-host]', :immediately
end

# If this is the master rabbitmq server, we need to setup all vhosts/queues/exchanges and bindings.
if node.attribute?('rabbitmq-master')
  execute "rabbit-config" do
    command "/etc/rabbitmq/rabbit-common.sh"
    action :nothing
    environment ({'HOME' => '/etc/rabbitmq'})
  end

# This loops through all apps and defines a service to execute setup
  rabbitapps.each do |app_name|
    unless "#{app_name}" == "rabbitmq"
      execute "#{app_name}-config" do
        command "/etc/rabbitmq/#{app_name}-rabbit.sh"
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
    notifies :run, 'execute[rabbit-config]', :immediately
  end

# This loops through all application entries to create the actual script to setup application entries
  rabbitapps.each do |app_name|
    unless "#{app_name}" == "rabbitmq"
      name_queue = data_bag_item("rabbitmq", app_name)
      template "/etc/rabbitmq/#{app_name}-rabbit.sh" do
        source "app_rabbit.erb"
        group "root"
        owner "root"
        mode '0755'
        variables(
          :queue_names  => name_queue['queues'],
          :exchange_names => name_queue['exchange'],
          :binding_names => name_queue['binding'],
          :vhost_names => name_queue['vhosts'],
          :userstring => name_queue['user'],
          :adminuser => rabbitcore['adminuser']
        )
        notifies :run, "execute[#{app_name}-config]", :immediately
      end
    end
  end

# This is for the slave entries that only need to be added to the cluster.
else
  template "/etc/rabbitmq/rabbit-guest.sh" do
    source "rabbit_guest.erb"
    group  "root"
    owner  "root"
    mode   "0755"
    notifies :run, 'execute[guest-remove]', :immediately
  end
end

template "/var/lib/rabbitmq/.erlang.cookie" do
  source "erlang.cookie.erb"
  owner  "rabbitmq"
  group  "rabbitmq"
  mode   "0600"
  variables( :cookie => rabbitcore['rabbit_cookie'] )
  notifies :restart, resources(:service => "rabbitmq-server")
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end
