include_recipe 'rf_rabbitmq::rabbitmqadmin'

node['rabbitmq']['exchanges'].each do |exchange|
  rf_rabbitmq_exchange exchange['exchange'] do
    vhost exchange['vhost']
    type exchange['type']
    user exchange['user']
    password exchange['password']
    action :add
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end