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

def declare_queue(admin_user, admin_password, vhost, queue, option_key, option_value)
  uri = URI.parse("http://#{node[:ipaddress]}:15672")
  http = Net::HTTP.new(uri.host, uri.port)
  headers={'Content-Type' => 'applications/json'}
  request = Net::HTTP::Post.new("/api/queues/#{URI.escape(vhost)}/#{URI.escape(queue)}", headers)
  request.basic_auth admin_user, admin_password
  request.body = {'durable' => true, 'auto_delete' => false, 'node' => "rabbit@#{node[:hostname]}", 'arguments' => {"#{option_key}" => "#{option_value}"}}.to_json
  Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request)}
 # request = http.put("/api/queues/#{URI.escape(vhost)}/#{URI.escape(queue)}")
 # response = New::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
  #response = http.put("/api/queues/#{URI.escape(vhost)}/#{URI.escape(queue)}") do |req|
  #  req.basic_auth admin_user, admin_password
  #  req.headers['Content-Type'] = "application/json"
  #  req.body = {'durable' => true, 'auto_delete' => false, 'node' => "rabbit@#{node[:hostname]}", 'arguments' => {"#{option_key}" => "#{option_value}"}}.to_json
  #end
  #decode_resource(response)
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
#    html_vhost = new_resource.vhost.gsub("/", "%2f")
#    uri = URI.parse("http://#{node[:ipaddress]}:15672")
#    http = Net::HTTP.new(uri.host, uri.port)
#    request = Net::HTTP::Post.new("/api/queues/#{html_vhost}/#{new_resource.queue}", initheader = {'Content-Type' => 'application/json'})
#    request.basic_auth "#{new_resource.admin_user}", "#{new_resource.admin_password}"
    #request.add_field('Content-Type', 'application/json')
#    request.body = {'durable' => true, 'auto_delete' => false, 'node' => "rabbit@#{node[:hostname]}", 'arguments' => {"#{new_resource.option_key}" => "#{new_resource.option_value}"}}.to_json
    #cmdStr = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
#    response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
#    cmdStr = puts response
#    execute cmdStr do
     declare_queue(new_resource.admin_user, new_resource.admin_password, new_resource.vhost, new_resource.queue, new_resource.option_key, new_resource.option_value)
     Chef::Log.debug "rabbitmq_queue_add: #{new_resource.queue}"
     Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}' on '#{new_resource.vhost}'."
     new_resource.updated_by_last_action(true)
    #end
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
    #html_vhost = new_resource.vhost.gsub("/", "%2f")
#    uri = URI.parse("http://#{node[:ipaddress]}:15672")
#    http = Net::HTTP.new(uri.host, uri.port)
#    request = Net::HTTP::Post.new("/api/queues/#{html_vhost)}/#{new_resource.queue}") #, initheader = {'Content-Type' => 'application/json'})
#    request.basic_auth "#{new_resource.admin_user}", "#{new_resource.admin_password}"
#    request.add_field('Content-Type', 'application/json')
#    request.body = {'durable' => true, 'auto_delete' => false, 'node' => "rabbit@#{node[:hostname]}", 'arguments' => {"#{new_resource.option_key}" => "#{new_resource.option_value}"}}.to_json
#    response = http.request(request)
#    cmdStr = decode_resource(response) #puts "#{response.code} #{response.message}: #{response.body}"
    #cmdStr = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(request) }
    #cmdStr = "curl -i -u #{new_resource.admin_user}:#{new_resource.admin_password} -H \"content-type:application/json\" -XPUT -d\"{\\\"durable\\\":true,\\\"auto_delete\\\":false,\\\"arguments\\\":{\\\"#{new_resource.option_key}\\\":#{new_resource.option_value}},\\\"node\\\":\\\"rabbit@#{node[:hostname]}\\\"}\" http://#{node[:ipaddress]}:15672/api/queues/#{html_vhost}/#{new_resource.queue}"
    #execute cmdStr do
     declare_queue(new_resource.admin_user, new_resource.admin_password, new_resource.vhost, new_resource.queue, new_resource.option_key, new_resource.option_value)
    Chef::Log.debug "rabbitmq_queue_add: #{new_resource.queue}"
    Chef::Log.info "Adding RabbitMQ Queue '#{new_resource.queue}' on '#{new_resource.vhost}'."
    new_resource.updated_by_last_action(true)
    #end
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
