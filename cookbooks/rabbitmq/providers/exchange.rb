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
require 'net/http'
require 'json'

def whyrun_supported
  true
end

def whyrun_mode?
  Chef::Config[:whyrun]
end

def exchange_exists?(name, vhost)
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

def binding_exists?(name, vhost, source, destination, routingkey)
  routekey = routingkey.gsub("#", "\#")
  cmdStr = "rabbitmqctl -q list_bindings -p #{vhost} | grep ^#{source} | grep -w #{destination} | grep -w \"#{routekey}\""
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
  unless exchange_exists?(new_resource.exchange, new_resource.vhost)
    cmdStr = "/usr/bin/rabbitmqadmin -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} declare exchange name=#{new_resource.exchange} auto_delete=false durable=true type=#{new_resource.type}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_exchange_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ exchange '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :set_binding do
  unless binding_exists?(new_resource.exchange, new_resource.vhost, new_resource.source, new_resource.destination, new_resource.routingkey)
    html_vhost = new_resource.vhost.gsub("/", "%2f")
    routekey = new_resource.routingkey.gsub("#", "\#")
    cmdStr = "/usr/bin/rabbitmqadmin -H #{node[:ipaddress]} -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} declare binding source=#{new_resource.source} destination_type=#{new_resource.type} destination=#{new_resource.destination} routing_key=#{routekey}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_binding_add: #{cmdStr}"
      Chef::Log.info "Adding RabbitMQ Binding '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end


action :set_binding_option do
  unless binding_exists?(new_resource.exchange, new_resource.vhost, new_resource.source, new_resource.destination, new_resource.routingkey)
    html_vhost = new_resource.vhost.gsub("/", "%2f")
    uri = URI.parse("http://#{node[:ipaddress]}:15672")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/api/bindings/#{html_vhost}/e/#{new_resource.source}/q/#{new_resource.destination}")
    request.basic_auth "#{new_resource.admin_user}", "#{new_resource.admin_password}"
    request.add_field('Content-Type', 'application/json')
    request.body = {'routing_key' => "#{new_resource.routingkey}", 'arguments' => {"#{new_resource.option_key}" => "#{new_resource.option_value}"}}.to_json
    response = http.start {|http| http.request(request)}
    unless response.kind_of?(Net::HTTPSuccess)
      raise ("Error creating Binding to source:#{new_resource.exchange} on #{new_resource.vhost} with #{new_resource.option_key}. Code:#{response.code}:#{response.message} to Request URL #{request.path} with Request method: #{request.method} and Request Body: #{request.body}")
    else
      Chef::Log.debug "rabbitmq_binding_add: #{new_resource.exchange}"
      Chef::Log.info "Adding RabbitMQ Binding '#{new_resource.exchange}' on '#{new_resource.vhost}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  if exchange_exists?(new_resource.exchange, new_resource.vhost)
    cmdStr = "/usr/bin/rabbitmqadmin -H #{node[:ipaddress]} -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} delete exchange name=#{new_resource.exchange}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_exchange_delete: #{cmdStr}"
      Chef::Log.info "Deleting RabbitMQ Exchange '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :clear_binding do
  if binding_exists?(new_resource.exchange, new_resource.vhost, new_resource.source, new_resource.destination, new_resource.routingkey)
    routekey = new_resource.routingkey.gsub("#", "\#")
    cmdStr = "/usr/bin/rabbitmqadmin -H #{node[:ipaddress]} -V #{new_resource.vhost} -u #{new_resource.admin_user} -p #{new_resource.admin_password} delete binding source=#{new_resource.source} destination_type=#{new_resource.type} destination=#{new_resource.destination} properties_key=#{routekey}"
    execute cmdStr do
      Chef::Log.debug "rabbitmq_binding_delete: #{cmdStr}"
      Chef::Log.info "Deleting RabbitMQ Binding '#{new_resource.exchange}'."
      new_resource.updated_by_last_action(true)
    end
  end
end
