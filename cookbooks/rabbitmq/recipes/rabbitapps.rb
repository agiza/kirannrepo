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
	  # Create a hashmap of permissions for the users
	  perms=Hash.new
	  unless name_queue["user_perm"].nil?
	    name_queue["user_perm"].split(" ").each do |user_perm|
          perm_user = user_perm.split("|")[0]
          perm_configure = user_perm.split("|")[1]
          perm_write = user_perm.split("|")[2]
          perm_read = user_perm.split("|")[3]

	  	  perms[perm_user]=Hash.new
    	  perms[perm_user][:configure]=perm_configure
		  perms[perm_user][:write]=perm_write
		  perms[perm_user][:read]=perm_read
		end
	  end

	  # Create user names and assign permissions for application vhost
      name_queue["user"].split(" ").each do |user|
        rabbituser = user.split("|")[0]
        rabbitpass = user.split("|")[1]
        rabbittag = user.split("|")[2]
        Chef::Log.debug("Creating user #{rabbituser} for #{vhost}")
        %w{add set_tags set_permissions}.each do |action|
          rabbitmq_user "#{rabbituser}" do
            vhost "#{vhost}"
            password "#{rabbitpass}"

			perm=perms[rabbituser]
			if perm.nil? 
			  puts "user_perm: using default perms"
			  permissions "^(amq\.gen.*|amq\.default)$ .* .*"
			else
			  puts "user_perm: using modified perms #{perms[:configure]} #{perms[:write]} #{perms[:read]}"
			  permissions "#{perms[:configure]} #{perms[:write]} #{perms[:read]}"
			end

            if rabbittag.nil? || rabbittag.empty?
              tag "management"
            else
              tag "#{rabbittag}"
            end
            action "#{action}"
          end
        end
      end
      # Grab the normal queues for creation and split them for a loop.
      if name_queue['queues'].nil?
        Chef::Log.info("No queues for #{app} in #{vhost} found to create.")
      else
        queues = name_queue['queues'].split(" ") 
        Chef::Log.debug("#{queues} will be created in #{vhost}")
        # Queues creation
        queues.each do |queuename|
          queue = queuename.split("|")[0]
          option_key = queuename.split('|')[1]
          option_value = queuename.split('|')[2]
          rabbitmq_queue "#{queue}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            if option_key.nil? || option_key.empty?
              option_key "null"
              option_value "null"
              action :add
            elsif option_key == "x-message-ttl"
              option_key "#{option_key}"
              option_value "#{option_value}"
              action :add_with_ttl
            else
              option_key "#{option_key}"
              option_value "#{option_value}"
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
        exchanges.each do |exchangename|
          exchange = "#{exchangename.split('|')[0]}"
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
      # Grab the normal bindings, split them for looping.
      # Bindings creation
      if name_queue['binding'].nil?
        Chef::Log.info("No Bindings for #{app} in #{vhost} found to create.")
      else
        bindings = name_queue['binding'].split(" ")
        bindings.each do |binding|
          name = binding.split('|')[0]
          option_key = binding.split('|')[4]
          option_value = binding.split('|')[5]
          rabbitmq_exchange "#{name}" do
            admin_user "#{admin_user}"
            admin_password "#{admin_password}"
            vhost "#{vhost}"
            source "#{binding.split('|')[0]}"
            type "#{binding.split('|')[1]}"
            destination "#{binding.split('|')[2]}"
            routingkey "#{binding.split('|')[3]}"
            if option_key.nil? || option_key.empty?
              option_key "null"
              option_value "null"
              action :set_binding
            else
              option_key "#{option_key}"
              option_value "#{option_value}"
              action :set_binding_option
            end
          end
        end
      end
    end
  end
end

