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

directory "/opt/elasticsearch/logs" do
  owner  "elasticsearch"
  group  "elasticsearch"
  mode   "0644"
  action :create
end

directory "/opt/elasticsearch/data" do
  owner  "elasticsearch"
  group  "elasticsearch"
  mode   "0644"
  action :create
end

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner  "elasticsearch"
  group  "elasticsearch"
  notifies :restart, resources(:service => "elasticsearch")
end

template "/etc/sysconfig/sysconfig-elasticsearch" do
  source "sysconfig-elasticsearch.erb"
  owner  "root"
  group  "root"
  notifies :restart, resources(:service => "elasticsearch")
end

service "elasticsearch" do
  action [:enable, :start]
end

