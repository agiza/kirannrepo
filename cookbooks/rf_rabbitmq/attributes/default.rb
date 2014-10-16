# Latest RabbitMQ.com version to install
default['rabbitmq']['version'] = '3.3.4'
# The distro versions may be more stable and have back-ported patches
default['rabbitmq']['use_distro_version'] = false

# being nil, the rabbitmq defaults will be used
default['rabbitmq']['nodename'] = nil
default['rabbitmq']['address'] = nil
default['rabbitmq']['port'] = nil
default['rabbitmq']['config'] = nil
default['rabbitmq']['logdir'] = nil
default['rabbitmq']['mnesiadir'] = '/var/lib/rabbitmq/mnesia'
default['rabbitmq']['service_name'] = 'rabbitmq-server'

# config file location
# http://www.rabbitmq.com/configure.html#define-environment-variables
# "The .config extension is automatically appended by the Erlang runtime."
default['rabbitmq']['config_root'] = '/etc/rabbitmq'
default['rabbitmq']['config'] = '/etc/rabbitmq/rabbitmq'
default['rabbitmq']['erlang_cookie_path'] = '/var/lib/rabbitmq/.erlang.cookie'

# rabbitmq.config defaults
default['rabbitmq']['default_user'] = 'guest'
default['rabbitmq']['default_pass'] = 'guest'

# Erlang kernel application options
# See http://www.erlang.org/doc/man/kernel_app.html
default['rabbitmq']['kernel']['inet_dist_listen_min'] = nil
default['rabbitmq']['kernel']['inet_dist_listen_max'] = nil

# Tell Erlang what IP to bind to
default['rabbitmq']['kernel']['inet_dist_use_interface'] = nil

# clustering
default['rabbitmq']['cluster'] = true
default['rabbitmq']['cluster_disk_nodes'] = []
default['rabbitmq']['erlang_cookie'] = 'RF_RealSearch_erlang_cookie_file'
default['rabbitmq']['cluster_partition_handling'] = 'ignore'

# resource usage
default['rabbitmq']['disk_free_limit_relative'] = 1000000000
default['rabbitmq']['vm_memory_high_watermark'] = 0.6
default['rabbitmq']['max_file_descriptors'] = 1024
default['rabbitmq']['open_file_limit'] = nil

# job control
default['rabbitmq']['job_control'] = 'initd'

# ssl
default['rabbitmq']['ssl'] = false
default['rabbitmq']['ssl_port'] = 5671
default['rabbitmq']['ssl_cacert'] = '/path/to/cacert.pem'
default['rabbitmq']['ssl_cert'] = '/path/to/cert.pem'
default['rabbitmq']['ssl_key'] = '/path/to/key.pem'
default['rabbitmq']['ssl_verify'] = 'verify_none'
default['rabbitmq']['ssl_fail_if_no_peer_cert'] = false
default['rabbitmq']['web_console_ssl'] = false
default['rabbitmq']['web_console_ssl_port'] = 15_671

# tcp listen options
default['rabbitmq']['tcp_listen_packet'] = 'raw'
default['rabbitmq']['tcp_listen_reuseaddr'] = true
default['rabbitmq']['tcp_listen_backlog'] = 128
default['rabbitmq']['tcp_listen_nodelay'] = true
default['rabbitmq']['tcp_listen_exit_on_close'] = false
default['rabbitmq']['tcp_listen_keepalive'] = false

# virtualhosts
default['rabbitmq']['virtualhosts'] = ['realsearch', 'RulesPublishing']
default['rabbitmq']['disabled_virtualhosts'] = []

# users - REALSearch and RulesManagement
default['rabbitmq']['enabled_users'] =
    [{:name => 'realsearch', :password => 'realsearch12', :tag => "administrator", :rights =>
        [{:vhost => "/", :conf => '.*', :write => '.*', :read => '.*'},
         {:vhost => "realsearch", :conf => '.*', :write => '.*', :read => '.*'}]
     },{:name => 'guest', :password => 'guest', :tag => "administrator", :rights =>
        [{:vhost => "/", :conf => '.*', :write => '.*', :read => '.*'},
         {:vhost => "realsearch", :conf => '.*', :write => '.*', :read => '.*'},
         {:vhost => "RulesPublishing", :conf => '.*', :write => '.*', :read => '.*'}]
    },{:name => 'rulesmgmt', :password => 'rulesmgmt12', :tag => "administrator", :rights =>
        [{:vhost => "/", :conf => '.*', :write => '.*', :read => '.*'},
         {:vhost => "RulesPublishing", :conf => '.*', :write => '.*', :read => '.*'}]
    }]
default['rabbitmq']['disabled_users'] = []

# plugins
default['rabbitmq']['enabled_plugins'] = ["rabbitmq_management"]
default['rabbitmq']['disabled_plugins'] = []

# platform specific settings
case node['platform_family']
  when 'smartos'
    default['rabbitmq']['service_name'] = 'rabbitmq'
    default['rabbitmq']['config_root'] = '/opt/local/etc/rabbitmq'
    default['rabbitmq']['config'] = '/opt/local/etc/rabbitmq/rabbitmq'
    default['rabbitmq']['erlang_cookie_path'] = '/var/db/rabbitmq/.erlang.cookie'
end

# Example HA policies
#default['rabbitmq']['policies']=[]
default['rabbitmq']['policies']['realsearch.data.policy']['pattern'] = 'realsearch\.data'
default['rabbitmq']['policies']['realsearch.data.policy']['params'] = {'ha-mode' => 'all'}
default['rabbitmq']['policies']['realsearch.data.policy']['priority'] = 0
default['rabbitmq']['policies']['realsearch.data.policy']['vhost'] = 'realsearch'


default['rabbitmq']['policies']['rulesmgmt.data.policy']['pattern'] = 'publishQueue'
default['rabbitmq']['policies']['rulesmgmt.data.policy']['params'] = {'ha-mode' => 'all'}
default['rabbitmq']['policies']['rulesmgmt.data.policy']['priority'] = 0
default['rabbitmq']['policies']['rulesmgmt.data.policy']['vhost'] = 'RulesPublishing'

default['rabbitmq']['disabled_policies'] = []

#Queues
default['rabbitmq']['queues'] =
    [{:name => 'realsearch.data.insert.queue', :autoDelete => 'false', :durability => 'true', :vhost => 'realsearch', :user => 'realsearch', :password => 'realsearch12'
     },
     {:name => 'realsearch.data.update.queue', :autoDelete => 'false', :durability => 'true', :vhost => 'realsearch', :user => 'realsearch', :password => 'realsearch12'
     },
     {:name => 'realsearch.data.delete.queue', :autoDelete => 'false', :durability => 'true', :vhost => 'realsearch', :user => 'realsearch', :password => 'realsearch12'
     },
     {:name => 'realsearch.data.audit.queue', :autoDelete => 'false', :durability => 'true', :vhost => 'realsearch', :user => 'realsearch', :password => 'realsearch12'
     },
     {:name => 'publishQueue', :autoDelete => 'false', :durability => 'true', :vhost => 'RulesPublishing', :user => 'rulesmgmt', :password => 'rulesmgmt12'
     }]

#Exchanges
default['rabbitmq']['exchanges'] =
    [{:exchange => 'toRabbit', :type => 'direct', :vhost => 'RulesPublishing', :user => 'rulesmgmt', :password => 'rulesmgmt12'
     }]

#Bindings
default['rabbitmq']['bindings'] =
    [{:exchange => 'toRabbit', :destination_type => 'queue', :destination => 'publishQueue', :routing_key => 'publishKey', :vhost => 'RulesPublishing', :user => 'rulesmgmt', :password => 'rulesmgmt12'
     }]