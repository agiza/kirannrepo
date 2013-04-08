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
require 'net/http'
require 'json'

def whyrun_supported
  true
end

def whyrun_mode?
  Chef::Config[:whyrun]
end

def queue_exists?(name, vhost)
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

def queue_option_exists?(name, vhost, option_key, option_value)
  cmdStr = "rabbitmqadmin -H #{node[:ipaddress]} -V #{vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} list queues name arguments.#{option_key} | grep -w #{name} | grep -w #{option_value}"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_option_exists?: #{cmdStr}"
  Chef::Log.debug "rabbitmq_option_exists?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue
    false
  end
end

def declare_queue?(admin_user, admin_password, vhost, queue, option_key, option_value)
  #if "#{option_key}" == "x-message-ttl"
  #  option_value = "#{option_value}"
  #else
  #  option_value = "\"#{option_value}\""
  #end
  uri = URI.parse("http://#{node[:ipaddress]}:15672")
  http = Net::HTTP.new(uri.host, uri.port)
  headers = {'Content-Type' => 'applications/json'}
  request = Net::HTTP::Put.new("/api/queues/#{vhost}/#{queue}", headers)
  request.basic_auth "#{admin_user}", "#{admin_password}"
  if "#{option_key}" == "x-message-ttl"
    request.set_form_data({'durable' => true, 'auto_delete' => false, 'node' => "rabbit@#{node[:hostname]}", 'arguments' => {"#{option_key}" => option_value}})
  else
    request.set_form_data({'durable' => true, 'auto_delete' => false, 'node' => "rabbit@#{node[:hostname]}", 'arguments' => {"#{option_key}" => "#{option_value}"}})
  end
  Chef::Log.info("#{request.url} Method: #{request.method} #{request.set_form_data}")
  response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request)}
  unless response.kind_of?(Net::HTTPSuccess)
    raise ("Error creating #{queue} on #{vhost} with #{option_key}. Code:#{response.code}:#{response.message} to Request URL #{request.path} with Request method: #{request.method} and Request Body: #{request.set_form_data}")
  end
end

action :add do
  unless queue_exists?(new_resource.queue, new_resource.vhost)
    if new_resource.admin_user.nil? || new_resource.admin_password.nil?
      Chef::Application.fatal!("rabbitmqadmin declare queue name #{new_resource.queue} fails with missing admin user/password.")
    end
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -H #{node[:ipaddress]} -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} declare queue name=#{new_resource.queue} durable=true"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_queue_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :add_with_option do
  unless queue_option_exists?(new_resource.queue, new_resource.vhost, new_resource.option_key, new_resource.option_value)
    if queue_exists?(new_resource.queue, new_resource.vhost)
      cmdStr = "/etc/rabbitmq/rabbitmqadmin -H #{node[:ipaddress]} -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} delete queue name=#{new_resource.queue}"
      execute cmdStr do
        Chef::Log.debug "rabbitmq_queue_delete: #{cmdStr}"
        Chef::Log.info "Deleting RabbitMQ Queue '#{new_resource.queue}'on '#{new_resource.vhost}'."
        new_resource.updated_by_last_action(true)
      end
    end
    html_vhost = new_resource.vhost.gsub("/", "%2f")
    unless declare_queue?(new_resource.admin_user, new_resource.admin_password, html_vhost, new_resource.queue, new_resource.option_key, new_resource.option_value)
      Chef::Log.error "Error adding RabbitMQ Queue '#{new_resource.queue}' on '#{new_resource.vhost}'."
    else
      Chef::Log.debug "rabbitmq_queue_add: #{new_resource.queue}"
      Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}' on '#{new_resource.vhost}'."
      new_resource.updated_by_last_action(true)
      Chef::Log.error "Error adding RabbitMQ Queue '#{new_resource.queue}' on '#{new_resource.vhost}'."
    end
  end
end

action :add_with_ttl do
  unless queue_option_exists?(new_resource.queue, new_resource.vhost, new_resource.option_key, new_resource.option_value)
    if queue_exists?(new_resource.queue, new_resource.vhost)
      cmdStr = "/etc/rabbitmq/rabbitmqadmin -H #{node[:ipaddress]} -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} delete queue name=#{new_resource.queue}"
      execute cmdStr do
        Chef::Log.debug "rabbitmq_queue_delete: #{cmdStr}"
        Chef::Log.info "Deleting RabbitMQ Queue '#{new_resource.queue}'on '#{new_resource.vhost}'."
        new_resource.updated_by_last_action(true)
      end
    end
    html_vhost = html_vhost = new_resource.vhost.gsub("/", "%2f")
    unless declare_queue?(new_resource.admin_user, new_resource.admin_password, html_vhost, new_resource.queue, new_resource.option_key, new_resource.option_value)
      Chef::Log.error "Error adding RabbitMQ Queue '#{new_resource.queue}' on '#{new_resource.vhost}'."
    else
      Chef::Log.debug "rabbitmq_queue_add: #{new_resource.queue}"
      Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}' on '#{new_resource.vhost}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  if queue_exists?(new_resource.queue, new_resource.vhost)
    cmdStr = "/etc/rabbitmq/rabbitmqadmin -H #{node[:ipaddress]} -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} delete queue name=#{new_resource.queue}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_queue_delete: #{cmdStr}"
      Chef::Log.info "Deleting RabbitMQ Queue '#{new_resource.queue}'on '#{new_resource.vhost}'."
      new_resource.updated_by_last_action(true)
    end
  end
end
