#
# Cookbook Name:: rabbitmq
# Recipe:: default
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


