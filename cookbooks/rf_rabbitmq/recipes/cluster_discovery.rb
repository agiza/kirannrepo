#
# Cookbook Name:: rabbitmq
# Recipe:: cluster_management
# Maintainer: cosmin.vasii@endava.com
# Installing RabbitMQ in a clustered fashion. Includes the default recipe, which just install RabbitMQ and erlang.

class Chef::Resource
  include Opscode::RabbitMQ
end

include_recipe 'rabbitmq::default'
include_recipe 'rabbitmq::plugin_management'

#Checking cookie file
if File.exists?(node['rabbitmq']['erlang_cookie_path'])
  existing_erlang_key =  File.read(node['rabbitmq']['erlang_cookie_path']).strip
else
  existing_erlang_key = ''
end

#If clustered enable, doing what needs to be done
if node['rabbitmq']['cluster'] && (node['rabbitmq']['erlang_cookie'] != existing_erlang_key)
  Chef::Log.info("Stoping node #{node['rabbitmq']['serice_name']} to change erlang cookie")
  log "stop #{node['rabbitmq']['serice_name']} to change erlang cookie" do
    notifies :stop, "service[#{node['rabbitmq']['service_name']}]", :immediately
  end

  #Setting the .erlang.cookie file based on the attributes. In order for the RabbitMQ cluster
  #to work, all  nodes should share the same cookie
  template node['rabbitmq']['erlang_cookie_path'] do
    source 'doterlang.cookie.erb'
    owner 'rabbitmq'
    group 'rabbitmq'
    mode 00400
    notifies :start, "service[#{node['rabbitmq']['service_name']}]", :immediately
    notifies :run, 'execute[reset-node]', :immediately
  end

  # Need to reset for clustering #
  execute 'reset-node' do
    command 'rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app'
    action :nothing
  end

end

if node['rabbitmq']['cluster']
  #Setting RabbitMQ in a cluster can be done in two ways: 1.auto-configuration 2.starting independent nodes,
  #find all the chef nodes which have a custom tag and which are in the same environment. The first node
  #will consider himself master, the others will try to join the cluster of all the nodes they found.
  #If option 1 is chosen you have to know all the nodes from the beginning and set the host (cluster_nodes field)
  #in the RabbitMQ configuration file. Note that the cluster configuration is applied only to fresh nodes.
  #A fresh nodes is a node which has just been reset or is being start for the first time. Thus, the automatic
  #clustering won't take place after restarts of nodes. This means that any change to the clustering via
  #rabbitmqctl will take precedence over the automatic clustering configuration.
  #Option 1 is not really good since we can't scale out and we might end up with no users, vhosts etc.
  #Option 2 is the one being chosen here. The master node will have a boolean attribute called "rf-rabbitmq-cluster:master",
  #which will differentiate it from the slaves, where the attribute will be false

  #Searching for the master node in the current environment.
  rabbitMQMster = search(:node, "tags:rf_rabbitmq_node_master AND chef_environment:#{node.chef_environment}")
  if rabbitMQMster.nil? || rabbitMQMster.empty?
    #No master found. Then set this node as a master and trigger the rabbitmq master recipe
    Chef::Log.info("There is no rabbitmq master detected in the environment #{node.chef_environment}, this node will be delegated as master.")
    tag('rf_rabbitmq_node_master')
    include_recipe 'rabbitmq::virtualhost_management'
    include_recipe 'rabbitmq::user_management'
    include_recipe 'rf_rabbitmq::queue_management'
    include_recipe 'rf_rabbitmq::exchange_management'
    include_recipe 'rf_rabbitmq::binding_management'
    include_recipe 'rabbitmq::policy_management'
  else
    # If this is the master, trigger the rabbitmq master recipe.
    if tagged?('rf_rabbitmq_node_master')
      Chef::Log.info("This is the master node.")
      include_recipe 'rabbitmq::virtualhost_management'
      include_recipe 'rabbitmq::user_management'
      include_recipe 'rf_rabbitmq::queue_management'
      include_recipe 'rf_rabbitmq::exchange_management'
      include_recipe 'rf_rabbitmq::binding_management'
      include_recipe 'rabbitmq::policy_management'
      # If this is not the master, trigger the worker recipe.
    else
      Chef::Log.info("This is a worker node.")

      #Run a script to join the cluster.
      results = "/tmp/output_clustering.txt"
      file results do
        action :delete
      end

      #Search all the nodes from the same environment and with the tag set
      rabbitMQClusterNodes = search(:node, "(tags:rf_rabbitmq_node_master OR tags:rf_rabbitmq_node_slave) AND chef_environment:#{node.chef_environment}")

      #For every node found, check if rabbit is running => rabbitmqctl -n <node_name> command
      #If is running the response should contain "amqp_client"
      #If running, join the cluster
      rabbitMQClusterNodes.each do |clusterNode|
        if node['hostname'] != clusterNode['hostname']
          Chef::Log.info("Worker node #{node['hostname']} joining cluster rabbit@#{clusterNode['hostname']}")
          bash "check node and join cluster" do
            cwd "/tmp"
            code <<-EOH
              STATUS=`rabbitmqctl -n rabbit@#{clusterNode['hostname']} status`
              echo $STATUS &>> #{results}
              if grep -q amqp_client <<<$STATUS
              then
                  echo 'This node is running!' &>> #{results};
                  statusRes=0;
              else
                  echo 'This node is not running!' &>> #{results};
                  statusRes=1;
              fi

              if [[ $statusRes == 0 ]]
              then
                  echo "Joining cluster with RabbitMQ node on #{clusterNode['hostname']}" &>> #{results};
                  rabbitmqctl stop_app &>> #{results}
                  rabbitmqctl join_cluster rabbit@#{clusterNode['hostname']} &>> #{results}
                  rabbitmqctl start_app &>> #{results}
                  res=0
              else
                  echo "Not Joining cluster with RabbitMQ node on #{clusterNode['hostname']}" &>> #{results}
                  res=1
              fi
              if [[ $res == 0 ]]
              then
                  break;
              fi
            EOH
          end
        end
      end

      #Print results from the bash commands from above
      ruby_block "Results" do
        only_if { ::File.exists?(results) }
        block do
          print "\n"
          File.open(results).each do |line|
            print line
          end
        end
      end

      #This is a slave
      tag('rf_rabbitmq_node_slave')
    end
  end
end
