#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
package "elasticsearch" do
  action :upgrade
end

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :enable
  action :start
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner  "root"
  group  "root"
  notifies :restart, resources(:service => "elasticsearch")
end

template "/etc/sysconfig/sysconfig-elasticsearch" do
  source "sysconfig-elasticsearch.erb"
  owner  "root"
  group  "root"
  notifies :restart, resources(:service => "elasticsearch")
end


