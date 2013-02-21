#
# Cookbook Name:: mongodb
# Recipe:: shard-enable
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "shard-enable" do
  command "/usr/local/bin/shard-enable"
  action :nothing
end

replicaset = node[:replicaset]
replicalist = []
if node.attribute?('performance')
  replicas = search(:node, "recipes:mongodb\\:\\:mongod OR role:mongodb-primary AND role:mongodb-#{replicaset} AND chef_environment:#{node.chef_environment}")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27017"
  end
else
  replicas = search(:node, "recipes:mongodb\\:\\:mongod OR role:mongodb-primary AND role:mongodb-#{replicaset} AND chef_environment:shared")
  replicas.each do |replica|
    replicalist << "#{replica[:ipaddress]}:27017"
  end
end

template "/data/db/shardadd.js" do
  source "shardadd.js.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :replicas => replicalist,
    :replicaset => replicaset
  )
  notifies :run, 'execute[shard-enable]'
end

template "/usr/local/bin/shard-enable" do
  source "shard-enable.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, 'execute[shard-enable]'
end

ruby_block "remove shard-enable from run list" do
  block do
    node.run_list.remove("mongodb::shard-enable")
  end
end

