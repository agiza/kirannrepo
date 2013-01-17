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
replicas = search(:node, "role:mongodb-primary AND role:mongodb-#{replicaset}")
replicas.each do |replica|
  replicalist << "#{replica[:ipaddress]}:27017"
end
replicas = search(:node, "role:mongodb-replica AND role:mongodb-#{replicaset}")
replicas.each do |replica|
  replicalist << "#{replica[:ipaddress]}:27027"
end
replicas = search(:node, "role:mongodb-replica1 AND role:mongodb-#{replicaset}")
replicas.each do |replica|
  replicalist << "#{replica[:ipaddress]}:27037"
end
template "/etc/mongo/rsadd.js" do
  source "rsadd.js.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :replicas => replicalist
  )
 # notifies :run, 'execute[replica-create]'
end

template "/usr/local/bin/replica-create" do
  source "replica-create.erb"
  owner  "root"
  group  "root"
  mode   "0755"
 # notifies :run, 'execute[replica-create]'
end

ruby_block "remove replica-create from run list" do
  block do
    node.run_list.remove("mongodb::replica-create")
  end
end

