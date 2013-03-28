#
# Cookbook Name:: rabbitmq
# Provider:: queue
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

def queue_exists?(name)
  cmdStr = "rabbitmqctl -q list_queues -p #{vhost} name | grep -w ^#{name}$"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_queue_exists?: #{cmdStr}"
  Chef::Log.debug "rabbitmq_queue_exists?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :add do
  unless queue_exists?(new_resource.queue)
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -H #{node[:ipaddress]} -V #{vhost} -u #{admin_user} -p #{admin_password} declare queue name=#{new_resource.queue} durable=true"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_queue_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :add_ttl do
  unless queue_exists?(new_resource.queue)
    html_vhost = vhost.gsub("/", "%2f")
    cmdStr = "curl -i -u #{admin_user}:#{admin_password} -H \"content-type:application/json\" -XPUT -d\"{\"durable\":true,\"auto_delete\":false,\"arguments\":{\"x-message-ttl\":432000000},\"node\":\"rabbit@#{node.hostname}\"}\" http://127.0.0.1:15672/api/queues/#{html_vhost}/#{new_resource.queue}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_queue_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :add_with_option do
  unless queue_exists?(new_resource.queue)
    cmdStr = "curl -i -u #{admin_user}:#{admin_password} -H \"content-type:application/json\" -XPUT -d\"{\"durable\":true,\"auto_delete\":false,\"arguments\":{\"#{option_key}\":\"#{option_value}\"},\"node\":\"rabbit@#{node[:hostname]}\"}\" http://#{node[:ipaddress]}:15672/api/queues/#{html_vhost}/#{new_resource.queue}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_queue_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  if queue_exists?(new_resource.queue)
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -H #{node[:ipaddress]} -V #{vhost} -u #{admin_user} -p #{admin_password} delete queue name=#{new_resource.queue}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_queue_delete: #{cmdStr}"
      Chef::Log.info "Deleting RabbitMQ Queue '#{new_resource.queue}'."
      new_resource.updated_by_last_action(true)
    end
  end
end
