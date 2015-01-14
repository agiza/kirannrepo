include_recipe 'rf_rabbitmq::rabbitmqadmin'

node['rabbitmq']['queues'].each do |queue|
  rf_rabbitmq_queue queue['name'] do
    vhost queue['vhost']
    durability queue['durability']
    autoDelete queue['autoDelete']
    autoDelete queue['autoDelete']
    user queue['user']
    password queue['password']
    action :add
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end