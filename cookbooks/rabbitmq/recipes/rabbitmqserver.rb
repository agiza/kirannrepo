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

#Build list of queues names for configuration
if data_bag_item("rabbitmq", "realtrans").nil? || data_bag_item("rabbitmq", "realtrans").empty?
  Chef::Log.info("No services returned from search.")
else
  realtrans_queue = data_bag_item("rabbitmq", "realtrans")
end
if data_bag_item("rabbitmq", "realdoc").nil? || data_bag_item("rabbitmq", "realdoc").empty?
  Chef::Log.info("No services returned from search.")
else
  realdoc_queue = data_bag_item("rabbitmq", "realdoc")
end
if data_bag_item("rabbitmq", "realservice").nil? || data_bag_item("rabbitmq", "realservice").empty?
  Chef::Log.info("No services returned from search.")
else
  realservice_queue = data_bag_item("rabbitmq", "realservice")
end
if data_bag_item("rabbitmq", "hubzu").nil? || data_bag_item("rabbitmq", "hubzu").empty?
  Chef::Log.info("No services returned from search.")
else
  hubzu_queue = data_bag_item("rabbitmq", "hubzu")
end

# Gather all available vhosts into a single variable.
vhost_names = []
vhost_names << realtrans_queue['vhosts']
vhost_names << realdoc_queue['vhosts']
vhost_names << realservice_queue['vhosts']
vhost_names << hubzu_queue['vhosts']

#Pull cookie value from databag
cookie = data_bag_item("rabbitmq", "rabbitmq")
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
  #notifies :run, 'execute[rabbit-host]', :immediately
end

template "/etc/rabbitmq/hosts.txt" do
  source "hosts.txt.erb"
  group  "root"
  owner  "root"
  mode   "0644"
  variables(:hostentries => hostentries)
  notifies :run, 'execute[rabbit-host]', :immediately
end

if node.attribute?('rabbitmq-master')
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
  
  execute "realservice-config" do
    command "/etc/rabbitmq/realservice-rabbit.sh"
    action :nothing
    environment ({'HOME' => '/etc/rabbitmq'})
  end

  execute "hubzu-config" do
    command "/etc/rabbitmq/hubzu-rabbit.sh"
    action :nothing
    environment ({'HOME' => '/etc/rabbitmq'})
  end

  template "/etc/rabbitmq/rabbit-common.sh" do
    source "rabbit_common.erb"
    group  "root"
    owner  "root"
    mode   "0755"
    variables(
      :rabbitnodes => rabbitservers,
      :vhost_names => vhost_names
    )
    notifies :run, 'execute[rabbit-config]', :immediately
  end

  if realtrans_queue.nil? || realtrans_queue.empty?
      Chef::Log.info("No services returned from search.")
  else
    template "/etc/rabbitmq/realtrans-rabbit.sh" do
      source "realtrans_rabbit.erb"
      group "root"
      owner "root"
      mode '0755'
      variables(
        :queue_names  => realtrans_queue['queues'],
        :exchange_names => realtrans_queue['exchange'],
        :binding_names => realtrans_queue['binding'],
        :vhost_names => realtrans_queue['vhosts'],
        :userstring => realtrans_queue['user']
      )
      notifies :run, 'execute[realtrans-config]', :immediately
    end
  end

  if realdoc_queue.nil? || realdoc_queue.empty?
      Chef::Log.info("No services returned from search.")
  else
    template "/etc/rabbitmq/realdoc-rabbit.sh" do
      source "realdoc_rabbit.erb"
      group "root"
      owner "root"
      mode "0755"
      variables(
        :queue_names => realdoc_queue['queues'],
        :exchange_names => realdoc_queue['exchange'],
        :binding_names => realdoc_queue['binding'],
        :vhost_names => realdoc_queue['vhosts'],
        :userstring => realdoc_queue['user']
      )
      notifies :run, 'execute[realdoc-config]', :immediately
    end
  end

  if realservice_queue.nil? || realservice_queue.empty?
      Chef::Log.info("No services returned from search.")
  else
    template "/etc/rabbitmq/realservice-rabbit.sh" do
      source "realservice_rabbit.erb"
      group "root"
      owner "root"
      mode "0755"
      variables(
        :queue_names => realservice_queue['queues'],
        :exchange_names => realservice_queue['exchange'],
        :binding_names => realservice_queue['binding'],
        :vhost_names => realservice_queue['vhosts'],
        :userstring => realservice_queue['user']
      )
      notifies :run, 'execute[realservice-config]', :immediately
    end
  end

  if hubzu_queue.nil? || hubzu_queue.empty?
      Chef::Log.info("No services returned from search.")
  else
    template "/etc/rabbitmq/hubzu-rabbit.sh" do
      source "hubzu_rabbit.erb"
      group "root"
      owner "root"
      mode "0755"
      variables(
        :queue_names => hubzu_queue['queues'],
        :exchange_names => hubzu_queue['exchange'],
        :binding_names => hubzu_queue['binding'],
        :vhost_names => hubzu_queue['vhosts'],
        :userstring => hubzu_queue['user']
      )
      notifies :run, 'execute[hubzu-config]', :immediately
    end
  end

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
  variables( :cookie => cookie['rabbit_cookie'] )
  notifies :restart, resources(:service => "rabbitmq-server")
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end
