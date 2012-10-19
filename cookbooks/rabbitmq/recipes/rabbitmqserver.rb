#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitmqserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::altirepo"

app_name = "rabbitmq-server-config"
app_version = node[:rabbitmqconfig_version]

package "rabbitmq-server" do
  provider Chef::Provider::Package::Yum
  action :upgrade
end

package "#{app_name}" do
  provider Chef::Provider::Package::Yum
  action :upgrade
end

execute "guest-remove" do
  command "/etc/rabbitmq/rabbit-guest.sh"
  action :nothing
end

service "rabbitmq-server" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

rabbitservers = search(:node, "role:rabbitserver").collect { |rabbitserver| "\'rabbit@#{rabbitserver}\'" }.join(", ").gsub!("node\[", "").gsub!("\]", "").gsub!(".#{node[:domain]}","")
hostentries = search(:node, "role:rabbitserver")

#Build list of queues names for configuration
realtrans_queue = data_bag_item("rabbitmq", "realtrans")
realdoc_queue = data_bag_item("rabbitmq", "realdoc")
realservice_queue = data_bag_item("rabbitmq", "realservice")
vhost_names = []
vhost_names << realtrans_queue['vhosts']
vhost_names << realdoc_queue['vhosts']
vhost_names << realservice_queue['vhosts']

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
  mode '0644'
  variables(
     :hostentries => hostentries
  )
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
