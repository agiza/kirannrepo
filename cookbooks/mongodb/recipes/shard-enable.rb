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

if node.attribute?('performance')
  environment = "#{node[:chef_environment]}"
else
  environment = "shared"
end

replicaset = node[:replicaset]
unless replicaset.nil? || replicaset.empty?
  replicalist = []

  %w{mongod replica replica1}.each do |app|
    if "#{app}" == "mongod"
      port = "27017"
    elsif "#{app}" == "replica"
      port = "27027"
    elsif "#{app}" == "replica1"
      port = "27037"
    end
    search(:node, "recipes:*\\:\\:#{app} AND replicaset:#{replicaset} AND chef_environment:#{environment}")
      replicalist << "#{replica[:ipaddress]}:#{port}"
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

else
  Chef::Log.error("No replicaset attribute is defined, This is REQUIRED. Skipping shard enable activity.")
end

