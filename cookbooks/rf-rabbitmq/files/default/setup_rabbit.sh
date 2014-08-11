#!/bin/bash

host=${1-$HOSTNAME}

#Setup VHosts
rabbitmqctl add_vhost realsearch

#Create User
rabbitmqctl add_user realsearch realsearch12
rabbitmqctl set_user_tags realsearch administrator


#Define Permissions
rabbitmqctl set_permissions -p realsearch realsearch ".*" ".*" ".*"
rabbitmqctl set_permissions -p / realsearch ".*" ".*" ".*"

