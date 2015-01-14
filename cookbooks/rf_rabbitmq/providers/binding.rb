action :add do
  vhostopt = "-V #{new_resource.vhost}" unless new_resource.vhost.nil?
  sourceopt = "source=#{new_resource.exchange}" unless new_resource.exchange.nil?
  destinationopt = "destination=#{new_resource.destination}" unless new_resource.destination.nil?
  destinationtypeopt = "destination_type=#{new_resource.destination_type}" unless new_resource.destination_type.nil?
  routingkeyopt = "routing_key=#{new_resource.routing_key}" unless new_resource.routing_key.nil?
  useropt = "-u #{new_resource.user}" unless new_resource.user.nil?
  passwdopt = "-p #{new_resource.password}" unless new_resource.password.nil?
  cmd = "/usr/local/bin/rabbitmqadmin declare binding #{vhostopt} #{useropt} #{passwdopt} #{destinationopt} #{sourceopt} #{routingkeyopt} #{destinationtypeopt}"
  execute cmd do
    Chef::Log.debug "rf_rabbitmq_binding_add: #{cmd}"
    Chef::Log.info "Adding RabbitMQ binding  with source '#{new_resource.exchange}'."
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if vhost_exists?(new_resource.vhost)
    vhostopt = "-V #{new_resource.vhost}" unless new_resource.vhost.nil?
    useropt = "-u #{new_resource.user}" unless new_resource.user.nil?
    passwdopt = "-p #{new_resource.password}" unless new_resource.password.nil?
    sourceopt = "source=#{new_resource.exchange}" unless new_resource.exchange.nil?
    destinationopt = "destination=#{new_resource.destination}" unless new_resource.destination.nil?
    destinationtypeopt = "destination=#{new_resource.destination_type}" unless new_resource.destination_type.nil?
    cmd = "/usr/local/bin/rabbitmqadmin delete binding #{useropt} #{passwdopt} #{destinationopt} #{sourceopt} #{destinationtypeopt} #{vhostopt}"
    execute cmd do
      Chef::Log.debug "rf_rabbitmq_queue_delete: #{cmd}"
      Chef::Log.info "Deleting RabbitMQ binding with source '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end
