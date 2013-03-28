#
# Cookbook Name:: rabbitmq
# Provider:: exchange
#
# Copyright 2011-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
def whyrun_supported
  true
end

def whyrun_mode?
  Chef::Config[:whyrun]
end

def exchange_exists?(name)
  cmdStr = "rabbitmqctl -q list_exchanges -p #{vhost} name | grep ^#{name}$"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_exchange_exists?: #{cmdStr}"
  Chef::Log.debug "rabbitmq_exchange_exists?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue
    false
  end
end

def binding_exists?(name)
  cmdStr = "rabbitmqctl -q list_bindings -p #{vhost} | grep ^#{source} | grep -w #{destination} | grep -w \"#{routingkey}\""
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_binding_exists?: #{cmdStr}"
  Chef::Log.debug "rabbitmq_binding_exists?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :add do
  unless exchange_exists?(new_resource.exchange)
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -V #{vhost} -u #{admin_user} -p #{admin_password} declare exchange name=#{new_resource.exchange} auto_delete=false durable=true type=topic"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_exchange_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ exchange '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :set_binding do
  unless binding_exists?(new_resource.exchange)
    html_vhost = vhost.gsub("/", "%2f")
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -H 127.0.0.1 -V #{vhost} -u #{admin_user} -p #{admin_password} declare binding source=#{source} destination_type=#{type} destination=#{destination} routing_key=#{routingkey}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_binding_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ Binding '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end


action :set_binding_option do
  unless binding_exists?(new_resource.exchange)
    html_vhost = vhost.gsub("/", "%2f")
    #cmdStr = "curl -i -u #{admin_user}:#{admin_password} -H \"content-type:application/json\" -XPOST -d\"{\"routing_key\":\"#{routingkey}\",\"arguments\":{\"#{option_key}\":\"#{option_value}\"}}\" http://127.0.0.1:15672/api/bindings/#{html_vhost}/e/#{source}/q/#{destination}"
    cmdStr = "curl -i -u #{admin_user}:#{admin_password} -H \'content-type:application/json\' -XPOST -d\'{\"routing_key\":\"#{routingkey}\",\"arguments\":{\"#{option_key}\":\"#{option_value}\"}}\' http://127.0.0.1:15672/api/bindings/#{html_vhost}/e/#{source}/q/#{destination}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_binding_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ Binding '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  if exchange_exists?(new_resource.exchange)
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -H 127.0.0.1 -V #{vhost} -u #{admin_user} -p #{admin_password} delete exchange name=#{new_resource.exchange}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_exchange_delete: #{cmdStr}"
      Chef::Log.info "Deleting RabbitMQ Exchange '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :clear_binding do
  if binding_exists?(new_resource.exchange)
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -H 127.0.0.1 -V #{vhost} -u #{admin_user} -p #{admin_password} delete binding source=#{source} destination_type=#{type} destination=#{destination} properties_key=#{routingkey}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_binding_delete: #{cmdStr}"
      Chef::Log.info "Deleting RabbitMQ Binding '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

