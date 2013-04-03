#
# Cookbook Name:: rabbitmq
# Recipe:: rabbitapps
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

#Pull Core rabbit from databag
begin
  rabbitcore = data_bag_item("rabbitmq", "rabbitmq")
    rescue Net::HTTPServerException
      raise "Error trying to pull rabbitmq info from rabbitmq data bag."
end
# Pull all entries in data_bag rabbitmq to get a list of apps for looping.
begin
  rabbitapps = data_bag("rabbitmq")
    rescue Net::HTTPServerException
      raise "Error loading rabbitmq data bag."
end

# Define admin user and password
admin_user = "#{rabbitcore['adminuser'].split("|")[0]}"
admin_password = "#{rabbitcore['adminuser'].split("|")[1]}"

# Now loop for each application.
rabbitapps.each do |app|
  name_queue = data_bag_item("rabbitmq", app)
  # Collect All of the vhosts for any specific application
  unless "#{app}" == "rabbitmq"
    appvhosts = []
    appvhosts = search(:node, "#{app}_amqp_vhost:*").map {|n| n["#{app}_amqp_vhost"]}
    name_queue = data_bag_item("rabbitmq", app)
    if name_queue["vhosts"].nil? || name_queue["vhosts"].empty?
      Chef::Log.info("No additional vhosts to add for this app.")
    else
      name_queue["vhosts"].split(" ").each do |vhost|
        appvhosts << vhost
      end
    end
  #end
    # Collect vhosts, sort and remove unique items, then loop for all vhosts
    appvhosts = appvhosts.collect { |vhost| "#{vhost}" }.uniq.sort.join(" ").split(" ")
    Chef::Log.debug("Current list of vhosts is #{appvhosts}")
    appvhosts.each do |vhost|
      # Create user names and assign permissions for application vhost
      name_queue["user"].split(" ").each do |user|
        rabbituser = user.split("|")[0]
        rabbitpass = user.split("|")[1]
        Chef::Log.debug("Creating user #{rabbituser} for #{vhost}")
        rabbitmq_user "#{rabbituser}" do
          vhost "#{vhost}"
          password "#{rabbitpass}"
          permissions "^(amq\.gen.*|amq\.default)$ .* .*"
          tag "management"
          action [:add, :set_tags, :set_permissions]
        end
      end
      # Grab the normal queues for creation and split them for a loop.
      if name_queue['queues'].nil?
        Chef::Log.info("No queues for #{app} in #{vhost} found to create.")
      else
        queues = name_queue['queues'].split(" ") 
        Chef::Log.debug("#{queues} will be created in #{vhost}")
        # Queues creation
        queues.each do |queue|
          rabbitmq_queue "#{queue}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            option_key "null"
            option_value "null"
            action :add
          end
        end
      end
      # Grab the queues with options and split them for a loop, will separate the options later.
      if name_queue['queues_options'].nil?
        Chef::Log.info("No queues with options for #{app} in #{vhost} found to create.")
      else
        queues_options = name_queue['queues_options'].split(" ")
        queues_options.each do |queue_option|
          rabbitmq_queue "#{queue_option.split('|')[0]}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            option_key "#{queue_option.split('|')[1]}"
            option_value "#{queue_option.split('|')[2]}"
            if option_key == "x-message-ttl"
              action :add_with_ttl
            else
              action :add_with_option
            end
          end
        end
      end
      # Grab the normal exchanges and split them for a loop.
      if name_queue['exchange'].nil?
        Chef::Log.info("No Exchanges for #{app} in #{vhost} found to create.")
      else
        exchanges = name_queue['exchange'].split(" ")
        # Exchanges creation
        exchanges.each do |exchange|
          rabbitmq_exchange "#{exchange}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            source "null"
            type "null"
            destination "null"
            routingkey "null"
            option_key "null"
            option_value "null"
            action :add
          end
        end
      end
      # Grab the exchanges with options and split them for a loop. will separate the options later.
      if name_queue['exchange_options'].nil?
        Chef::Log.info("No Exchanges with options for #{app} in #{vhost} found to create.")
      else
        exchanges_options = name_queue['exchange_options'].split(" ")
        exchanges_options.each do |exchange_option|
          rabbitmq_exchange "#{exchange_option.split('|')[0]}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            source "null"
            type "null"
            destination "null"
            routingkey "null"
            option_key "#{exchange_option.split('|')[1]}"
            option_value "#{exchange_option.split('|')[2]}"
            action :add
          end
        end
      end
      # Grab the normal bindings, split them for looping.
      # Bindings creation
      if name_queue['binding'].nil?
        Chef::Log.info("No Bindings for #{app} in #{vhost} found to create.")
      else
        bindings = name_queue['binding'].split(" ")
        bindings.each do |binding|
          rabbitmq_exchange "#{binding.split('|')[0]}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            source "#{binding.split('|')[0]}"
            type "#{binding.split('|')[1]}"
            destination "#{binding.split('|')[2]}"
            routingkey "#{binding.split('|')[3]}"
            option_key "null"
            option_value "null"
            action :set_binding
          end
        end
      end
      # Grab the bindings with options and split them for loop, separate options later.
      if name_queue['binding_options'].nil?
        Chef::Log.info("No Bindings with options for #{app} in #{vhost} found to create.")
      else
        bindings_options = name_queue['binding_options'].split(" ")
        bindings_options.each do |binding_option|
          rabbitmq_exchange "#{binding_option.split('|')[0]}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            source "#{binding_option.split('|')[0]}"
            type "#{binding_option.split('|')[1]}"
            destination "#{binding_option.split('|')[2]}"
            routingkey "#{binding_option.split('|')[3]}"
            option_key "#{binding_option.split('|')[4]}"
            option_value "#{binding_option.split('|')[5]}"
            action :set_binding_option
          end
        end
      end
    end
  end
end
