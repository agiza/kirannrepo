action :add do
  vhostopt = "-V #{new_resource.vhost}" unless new_resource.vhost.nil?
  durabilityopt = "durable=#{new_resource.durability}" unless new_resource.durability.nil?
  autodeleteopt = "auto_delete=#{new_resource.autoDelete}" unless new_resource.autoDelete.nil?
  argumentsopt = "#{new_resource.arguments}" unless new_resource.vhost.nil?
  useropt = "-u #{new_resource.user}" unless new_resource.user.nil?
  passwdopt = "-p #{new_resource.password}" unless new_resource.password.nil?
  cmd = "/usr/local/bin/rabbitmqadmin declare queue name=#{new_resource.name} #{vhostopt} #{useropt} #{passwdopt} #{durabilityopt} #{autodeleteopt} #{argumentsopt}"
  execute cmd do
    Chef::Log.debug "rf_rabbitmq_queue_add: #{cmd}"
    Chef::Log.info "Adding RabbitMQ queue '#{new_resource.name}'."
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
    useropt = "-u #{new_resource.user}" unless new_resource.user.nil?
    passwdopt = "-p #{new_resource.password}" unless new_resource.password.nil?
    cmd = "/usr/local/bin/rabbitmqadmin delete queue #{new_resource.name} #{useropt} #{passwdopt}"
    execute cmd do
      Chef::Log.debug "rf_rabbitmq_queue_delete: #{cmd}"
      Chef::Log.info "Deleting RabbitMQ queue '#{new_resource.name}'."
      new_resource.updated_by_last_action(true)
    end
end
