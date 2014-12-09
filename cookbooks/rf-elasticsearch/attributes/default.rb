# Load settings from data bag 'elasticsearch/settings'
#
settings = Chef::DataBagItem.load('elasticsearch', 'settings')[node.chef_environment] rescue {}
Chef::Log.debug "Loaded settings: #{settings.inspect}"

#Jdk
#override[:java][:openjdk_packages] = [
#  "openjdk-7-jdk", "openjdk-7-jre-headless"
#  ]
#node.override[:java][:openjdk_packages] = ["java-1.7.0-openjdk", "java-1.7.0-openjdk-devel"]

# Initialize the node attributes with node attributes merged with data bag attributes
#
node.default[:elasticsearch] ||= {}
node.normal[:elasticsearch] ||= {}

include_attribute 'elasticsearch::customize'

node.normal[:elasticsearch] = DeepMerge.merge(node.default[:elasticsearch].to_hash, node.normal[:elasticsearch].to_hash)
node.normal[:elasticsearch] = DeepMerge.merge(node.normal[:elasticsearch].to_hash, settings.to_hash)

node.default[:testing_setting] = "1"

# === VERSION AND LOCATION
#
normal[:elasticsearch][:version] = "1.1.1"
normal[:elasticsearch][:host] = "http://download.elasticsearch.org"
normal[:elasticsearch][:repository] = "elasticsearch/elasticsearch"
normal[:elasticsearch][:filename] = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
normal[:elasticsearch][:download_url] = [node.elasticsearch[:host], node.elasticsearch[:repository], node.elasticsearch[:filename]].join('/')

# === NAMING
#
override.elasticsearch[:cluster][:name] = "rf-realsearch"
default.elasticsearch[:node][:name] = node.name

# === USER & PATHS
#
default.elasticsearch[:dir] = "/usr/local"
default.elasticsearch[:bindir] = "/usr/local/bin"
default.elasticsearch[:user] = "elasticsearch"
default.elasticsearch[:uid] = nil
default.elasticsearch[:gid] = nil

default.elasticsearch[:path][:conf] = "/usr/local/etc/elasticsearch"
default.elasticsearch[:path][:data] = "/usr/local/var/data/elasticsearch"
default.elasticsearch[:path][:logs] = "/usr/local/var/log/elasticsearch"

normal.elasticsearch[:path][:init][:templates] = "/usr/local/etc/elasticsearch/templates"
normal.elasticsearch[:path][:init][:scripts] = "/usr/local/etc/elasticsearch/scripts"

default.elasticsearch[:path][:indices][:mappings][:audit] = "/usr/local/elasticsearch/scripts/mappings/audit"
default.elasticsearch[:path][:indices][:mappings][:workflow] = "/usr/local/elasticsearch/scripts/mappings/workflow"


default.elasticsearch[:pid_path] = "/usr/local/var/run"
default.elasticsearch[:pid_file] = "#{node.elasticsearch[:pid_path]}/#{node.elasticsearch[:node][:name].to_s.gsub(/\W/, '_')}.pid"

default.elasticsearch[:templates][:elasticsearch_env] = "elasticsearch-env.sh.erb"
default.elasticsearch[:templates][:elasticsearch_yml] = "elasticsearch.yml.erb"
default.elasticsearch[:templates][:logging_yml] = "logging.yml.erb"

# === MEMORY
#
# Maximum amount of memory to use is automatically computed as one half of total available memory on the machine.
# You may choose to set it in your node/role configuration instead.
#
allocated_memory = "#{(node.memory.total.to_i * 0.6).floor / 1024}m"
default.elasticsearch[:allocated_memory] = allocated_memory

# === GARBAGE COLLECTION SETTINGS
#
default.elasticsearch[:gc_settings] =<<-CONFIG
  -XX:+UseParNewGC
  -XX:+UseConcMarkSweepGC
  -XX:CMSInitiatingOccupancyFraction=75
  -XX:+UseCMSInitiatingOccupancyOnly
  -XX:+HeapDumpOnOutOfMemoryError
CONFIG

# === LIMITS
#
# By default, the `mlockall` is set to true: on weak machines and Vagrant boxes,
# you may want to disable it.
#
default.elasticsearch[:bootstrap][:mlockall] = (node.memory.total.to_i >= 1048576 ? true : false)
default.elasticsearch[:limits][:memlock] = 'unlimited'
default.elasticsearch[:limits][:nofile] = '64000'

# === PRODUCTION SETTINGS
#
default.elasticsearch[:index][:mapper][:dynamic] = true
normal.elasticsearch[:action][:auto_create_index] = false
default.elasticsearch[:action][:disable_delete_all_indices] = true
default.elasticsearch[:node][:max_local_storage_nodes] = 1

default.elasticsearch[:discovery][:zen][:ping][:multicast][:enabled] = false
default.elasticsearch[:discovery][:zen][:minimum_master_nodes] = 1
default.elasticsearch[:gateway][:type] = 'local'
default.elasticsearch[:gateway][:expected_nodes] = 1
default.elasticsearch[:thread_stack_size] = "256k"
default.elasticsearch[:env_options] = ""

# === OTHER SETTINGS
#
default.elasticsearch[:skip_restart] = false
default.elasticsearch[:skip_start] = false

default.elasticsearch[:discovery][:search_query] = "chef_environment:\"#{node.chef_environment}\" AND elasticsearch_cluster_name:\"#{node[:elasticsearch][:cluster][:name]}\""

# === PORT
#
default.elasticsearch[:http][:port] = 9200

# === CUSTOM CONFIGURATION
#
default.elasticsearch[:index][:gc_deletes] = '2h'
default.elasticsearch[:threadpool][:search][:queue_size] = 2000
default.elasticsearch[:threadpool][:index][:queue_size] = 1000
default.elasticsearch[:threadpool][:bulk][:queue_size] = 500

default.elasticsearch[:custom_config] = {
    "script.disable_dynamic" => true,
    "index.gc_deletes" => "#{node.elasticsearch[:index][:gc_deletes]}",
    "threadpool.search.queue_size" => "#{node.elasticsearch[:threadpool][:search][:queue_size]}",
    "threadpool.index.queue_size" => "#{node.elasticsearch[:threadpool][:index][:queue_size]}",
    "threadpool.bulk.queue_size" => "#{node.elasticsearch[:threadpool][:bulk][:queue_size]}"
}

# === LOGGING
#
# See `attributes/logging.rb`
#
default.elasticsearch[:logging] = {}

# --------------------------------------------------
# NOTE: Setting the attributes for elasticsearch.yml
# --------------------------------------------------
#
# The template uses the `print_value` extension method to print attributes with a "truthy"
# value, set either in data bags, node attributes, role override attributes, etc.
#
# It is possible to set *any* configuration value exposed by the Elasticsearch configuration file.
#
# For example:
#
#     <%= print_value 'cluster.routing.allocation.node_concurrent_recoveries' -%>
#
# will print a line:
#
#     cluster.routing.allocation.node_concurrent_recoveries: <VALUE>
#
# if the either of following node attributes is set:
#
# * `node.cluster.routing.allocation.node_concurrent_recoveries`
# * `node['cluster.routing.allocation.node_concurrent_recoveries']`
#
# The default attributes set by the cookbook configure a minimal set inferred from the environment
# (eg. memory settings, node name), or reasonable defaults for production.
#
# The template is based on the elasticsearch.yml file from the Elasticsearch distribution;
# to set other configurations, set the `node.elasticsearch[:custom_config]` attribute in the
# node configuration, `elasticsearch/settings` data bag, role/environment definition, etc:
#
#     // ...
#     'threadpool.index.type' => 'fixed',
#     'threadpool.index.size' => '2'
#     // ...
#
