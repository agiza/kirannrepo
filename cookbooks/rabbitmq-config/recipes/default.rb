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
  version "2.7.1-1"
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

template "/etc/rabbitmq/rabbitmq.config" do
  case node[:chef_environment]
    when "QA"
    source "rabbitmq.config.qa.erb"
    when "Demo"
    source "rabbitmq.config.demo.erb"
    when "UAT"
    source "rabbitmq.config.uat.erb"
    when "Production"
    source "rabbitmq.config.prod.erb"
    when "_default"
    source "rabbitmq.config.erb"
    end
  group 'root'
  owner 'root'
  mode '0644'
  notifies :restart, resources(:service => "rabbitmq-server")
end

execute "queue-config" do
  command "/etc/rabbitmq/realtrans-rabbit.sh"
  action :run
  environment ({'HOME' => '/etc/rabbitmq'})
end

