action :add do
  vhostopt = "-V #{new_resource.vhost}" unless new_resource.vhost.nil?
  typeopt = "type=#{new_resource.type}" unless new_resource.type.nil?
  useropt = "-u #{new_resource.user}" unless new_resource.user.nil?
  passwdopt = "-p #{new_resource.password}" unless new_resource.password.nil?
  cmd = "/usr/local/bin/rabbitmqadmin declare exchange name=#{new_resource.name} #{vhostopt} #{useropt} #{passwdopt}  #{typeopt}"
  execute cmd do
    Chef::Log.debug "rf_rabbitmq_exchange_add: #{cmd}"
    Chef::Log.info "Adding RabbitMQ exchange '#{new_resource.name}'."
    new_resource.updated_by_last_action(true)
  end
end
