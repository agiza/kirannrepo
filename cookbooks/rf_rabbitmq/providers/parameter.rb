#
# Cookbook Name:: rf-rabbitmq
# Provider:: federation#
# Copyright 2014, Altisource
# Sets clears and lists a parameter

require 'shellwords'

def parameter_exists?(vhost, name)
  cmd = 'rabbitmqctl list_parameters'
  cmd << " -p #{Shellwords.escape vhost}" unless vhost.nil?
  cmd << " |grep '#{name}\\b'"

  cmd = Mixlib::ShellOut.new(cmd)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :set do
  unless parameter_exists?(new_resource.vhost, new_resource.parameter)
    cmd = 'rabbitmqctl set_parameter'
    cmd << " -p #{new_resource.vhost}" unless new_resource.vhost.nil?
    cmd << " #{new_resource.component}"
    cmd << " #{new_resource.parameter}"
    cmd << " '{"
    first_param = true
    new_resource.options.each do |key, value|
      cmd << ',' unless first_param
      if value.kind_of? String
        cmd << "\"#{key}\":\"#{value}\""
      else
        cmd << "\"#{key}\":#{value}"
      end
      first_param = false
    end
    cmd << "}'"

    execute "set_parameter #{new_resource.parameter}" do
      command cmd
    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Done setting RabbitMQ parameter '#{new_resource.parameter}'."
  end	
end

action :clear do
  if parameter_exists?(new_resource.vhost, new_resource.parameter)
    cmd = 'rabbitmqctl clear_parameter'
	cmd << " -p #{new_resource.vhost}" unless new_resource.vhost.nil?
	cmd << " #{new_resource.component}"
	cmd << " #{new_resource.parameter}"
	execute "clear_parameter #{new_resource.parameter}" do
      command cmd
    end
    new_resource.updated_by_last_action(true)
    Chef::Log.info "Done clearing RabbitMQ parameter '#{new_resource.parameter}'."
  end
end

action :list do
  cmd = 'list_parameters'
  cmd << " -p #{new_resource.vhost}" unless new_resource.vhost.nil? 
  execute '' do
    command cmd
  end
  new_resource.updated_by_last_action(true)
end