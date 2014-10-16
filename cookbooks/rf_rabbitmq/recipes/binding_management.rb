include_recipe 'rf_rabbitmq::rabbitmqadmin'

node['rabbitmq']['bindings'].each do |binding|
  rf_rabbitmq_binding binding['exchange'] do
    vhost binding['vhost']
    user binding['user']
    password binding['password']
    exchange binding['exchange']
    destination binding['destination']
    routing_key binding['routing_key']
    destination_type binding['destination_type']
    action :add
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end