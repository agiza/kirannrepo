#
# Cookbook Name:: mongodb
# Recipe:: replica-create
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

#include_recipe "altitomcat"

execute "replica-create" do
  command "/usr/local/bin/replica-create"
  action :nothing
end

replicaset = node[:replicaset]
replicalist = []
if node.environment?('performance')
  replicas = search(:node, "recipes:mongodb\\:\\:mongod OR role:mongodb-primary AND role:mongodb-#{replicaset} AND chef_environment:#{node.chef_environment}")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27017"
  end
  replicas = search(:node, "recipes:mongodb\\:\\:replica OR role:mongodb-replica AND role:mongodb-#{replicaset} AND chef_environment:#{node.chef_environment}")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27027"
  end
  replicas = search(:node, "recipes:mongodb\\:\\:replica1 OR role:mongodb-replica1 AND role:mongodb-#{replicaset} AND chef_environment:#{node.chef_environment}")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27037"
  end
else
  replicas = search(:node, "recipes:mongodb\\:\\:mongod OR role:mongodb-primary AND role:mongodb-#{replicaset} AND chef_environment:shared")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27017"
  end
  replicas = search(:node, "recipes:mongodb\\:\\:replica OR role:mongodb-replica AND role:mongodb-#{replicaset} AND chef_environment:shared")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27027"
  end
  replicas = search(:node, "recipes:mongodb\\:\\:replica1 OR role:mongodb-replica1 AND role:mongodb-#{replicaset} AND chef_environment:shared")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27037"
  end
end
template "/etc/mongo/rsadd.js" do
  source "rsadd.js.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :replicas => replicalist
  )
  notifies :run, 'execute[replica-create]'
end

template "/usr/local/bin/replica-create" do
  source "replica-create.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, 'execute[replica-create]'
end

ruby_block "remove replica-create from run list" do
  block do
    node.run_list.remove("mongodb::replica-create")
  end
end

