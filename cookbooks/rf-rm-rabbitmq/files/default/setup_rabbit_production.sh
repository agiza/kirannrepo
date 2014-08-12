#!/bin/bash

#enable plugin management and start
sudo rabbitmq-plugins enable rabbitmq_management
sudo /etc/init.d/rabbitmq-server start
sudo rabbitmqctl status

#add rabbitmqadmin
sudo wget http://guest:guest@localhost:55672/cli/rabbitmqadmin
sudo chmod +x rabbitmqadmin
sudo cp -f rabbitmqadmin /usr/local/bin/rabbitmqadmin

#Setup VHosts
rabbitmqctl add_vhost RulesPublishing

#Create User
rabbitmqctl add_user rulesmgmt rulesmgmt12
rabbitmqctl set_user_tags rulesmgmt administrator

c=1
vhost_ready=$(sudo rabbitmqctl list_vhosts | grep RulesPublishing)
while [ $c -le 20 ] && [ -z "$vhost_ready" -o "$vhost_ready" == " " ]; do
	echo "Wait 2 seconds and try again"
	sleep 2
	vhost_ready=$(sudo rabbitmqctl list_vhosts | grep RulesPublishing)
	(( c++ ))
done

#Define Permissions
rabbitmqctl set_permissions -p RulesPublishing rulesmgmt ".*" ".*" ".*"

#create the queues
rabbitmqadmin -H localhost -u rulesmgmt -p rulesmgmt12 -V RulesPublishing declare queue name=publishQueue auto_delete=false durable=true

#declare the exchange
rabbitmqadmin  -H localhost -u rulesmgmt -p rulesmgmt12 -V RulesPublishing declare exchange name=toRabbit type=direct

#declare the binding
rabbitmqadmin  -H localhost -u rulesmgmt -p rulesmgmt12 -V RulesPublishing declare binding source=toRabbit destination_type=queue destination=publishQueue routing_key=publishKey