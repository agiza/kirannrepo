#
# Cookbook Name:: mongodb
# Recipe:: replica-create
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

#execute "replica-create" do
#  command "/usr/local/bin/replica-create"
#  action :nothing
#end

replicaset = node[:replicaset]
replicalist = []
if node.attribute?('performance')
  environment = "#{node[:chef_environment]}"
else
  environment = "shared"
end

unless replicaset.nil? || replicaset.empty? || replicaset.nil? || replicaset.empty?
  %w{mongod mongod replica replica1}.each do |app|
    replicas = search(:node, "recipes:*\\:\\:#{app} AND replicaset:#{node[:replicaset]} AND chef_environment:#{environment}")
    replicas.each do |replica|
      if "#{app}" == "mongod"
        port = "27017"
      elsif "#{app}" == "replica"
        port = "27027"
      elsif "#{app}" == "replica1"
        port = "27037"
      end
      Chef::Log.info("Adding #{replica[:ipaddress]}:#{port} to the replicaset.")
      replicalist << "#{replica[:ipaddress]}:#{port}"
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
    #notifies :run, 'execute[replica-create]'
  end

  mongodb_replica "#{node[:replicaset]}" do
    action :create
  end
  
  ruby_block "remove replica-create from run list" do
    block do
      node.run_list.remove("mongodb::replica-create")
    end
  end
else
  Chef::Log.error("There is either no replicaset or replicalist found for #{node[:replicaset]} in the #{environment} environment. Unable to proceed. Skipping replicaset creation.")
end

