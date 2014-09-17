#
# Cookbook Name:: rabbitmq
# Recipe:: cluster_management
# Maintainer: cosmin.vasii@endava.com
# Installing RabbitMQ in a clustered fashion. Includes the default recipe, which just install RabbitMQ and erlang.

class Chef::Resource
  include Opscode::RabbitMQ
end

include_recipe 'rabbitmq-cluster::default'

template "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source 'rabbitmq.config.erb'
  owner 'root'
  group 'root'
  mode 00644
  variables(
      :kernel => format_kernel_parameters
  )
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

#Checking cookie file
if File.exists?(node['rabbitmq']['erlang_cookie_path'])
  existing_erlang_key =  File.read(node['rabbitmq']['erlang_cookie_path']).strip
else
  existing_erlang_key = ''
end

#If clustered enable, doing what needs to be done
if node['rabbitmq']['cluster'] && (node['rabbitmq']['erlang_cookie'] != existing_erlang_key)
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

  #Setting RabbitMQ in a cluster can be done in two ways: 1.auto-configuration 2.starting independent nodes,
  #find all the chef nodes which have a custom attribute and which are in the same environment. The first node
  #will consider himself master, the others will try to join the cluster of all the nodes they found.
  #If option 1 is chosen you have to know all the nodes from the beginning and set the host (cluster_nodes field)
  #in the RabbitMQ configuration file. Note that the cluster configuration is applied only to fresh nodes.
  #A fresh nodes is a node which has just been reset or is being start for the first time. Thus, the automatic
  #clustering won't take place after restarts of nodes. This means that any change to the clustering via
  #rabbitmqctl will take precedence over the automatic clustering configuration.
  #Option 1 is not really good since we can't scale out and we might end up with no users, vhosts etc.
  #Option 2 is the one being chosen here. The master node will have a boolean attribute called "rf-rabbitmq-master:true",
  #which will differentiate it from the slaves, where the attribute will be false

  #Searching for the master node in the current environment.
  #TODO the attribute is hardcoded - should we take it out as an atrtibute
  rabbitmaster = search(:node, "rf-rabbitmq-master:true AND chef_environment:#{node.chef_environment}")
  if rabbitmaster.nil? || rabbitmaster.empty?
    #No master found. Then set this node as a master and trigger the rabbitmq master recipe
    Chef::Log.info("There is no rabbitmq master detected in the environment #{node.chef_environment}, this node will be delegated as master.")
    node.set['rf-rabbitmq-master'] = true
    include_recipe "rabbitmq-cluster::master_management"
  else
    # TODO check if there are more than one master
    # If this is the master, trigger the rabbitmq master recipe.
    if node.attribute?('rf-rabbitmq-master')
      Chef::Log.info("This is the master node. Why is the recipe ran again? It was already bootstrapped as a master!")
      # TODO if this the master do we still need to run the recipe?
      include_recipe "rabbitmq-cluster::master_management"
      # If this is not the master, trigger the worker recipe.
    else
      Chef::Log.info("This is a worker node.")
      #For a slave just include the plugin_management recipe. Users, policies, vhosts will be taken from the master
      include_recipe 'rabbitmq-cluster::plugin_management'

      #Run a script to join the cluster.

      results = "/tmp/output_clustering.txt"
      file results do
        action :delete
      end

      #Search all the nodes from the same environment and with the attribute rf-rabbitmq-master
      rabbitClusterNodes = search(:node, "rf-rabbitmq-master:* AND chef_environment:#{node.chef_environment}")

      #For every node found, check if rabbit is running => rabbitmqctl -n <node_name> command
      #If is running the response should contain "amqp_client" => TODO Maybe this is not the best way to check if rabbit is running
      #If running, join the cluster
      #TODO What is bad about this recipe is that it will join with each node from the cluster. It won't fail since rabbitmqctl will say the node is already a member.
      rabbitClusterNodes.each do |clusterNode|
        if node['fqdn'] != clusterNode['fqdn']
          Chef::Log.info("Worker node #{node['fqdn']} joining cluster rabbit@#{clusterNode['fqdn']}")
          bash "check node and join cluster" do
            cwd "/tmp"
            code <<-EOH
              STATUS=`rabbitmqctl -n rabbit@#{clusterNode['fqdn']} status`
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
                  echo "Joining cluster with RabbitMQ node on #{clusterNode['fqdn']}" &>> #{results};
                  rabbitmqctl stop_app &>> #{results}
                  rabbitmqctl join_cluster rabbit@#{clusterNode['fqdn']} &>> #{results}
                  rabbitmqctl start_app &>> #{results}
                  res=0
              else
                  echo "Not Joining cluster with RabbitMQ node on #{clusterNode['fqdn']}" &>> #{results}
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
      node.set['rf-rabbitmq-master'] = false
    end
  end
end
