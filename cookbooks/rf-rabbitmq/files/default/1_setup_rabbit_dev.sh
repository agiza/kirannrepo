#!/bin/bash

#Run this script from the machine on which you are installing

#remove previous erlang, epel and rabbit installation
#uncomment this for the proper situation
#sudo yum -y remove erlang
#sudo yum -y remove erlang-*
#sudo yum -y remove epel*
#sudo rm -R -f /var/lib/rabbitmq

#install erlang and rabbit
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo yum -y install erlang
sudo rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.1.5/rabbitmq-server-3.1.5-1.noarch.rpm

#enable plugin management and start
sudo rabbitmq-plugins enable rabbitmq_management
sudo /etc/init.d/rabbitmq-server start
sudo rabbitmqctl status

#add rabbitmqadmin
sudo wget http://localhost:15672/cli/rabbitmqadmin
sudo chmod +x rabbitmqadmin
sudo cp -f rabbitmqadmin /usr/local/bin/rabbitmqadmin

#create the 4 queues
rabbitmqadmin -H localhost declare queue name=realsearch.data.insert.queue auto_delete=false durable=true
rabbitmqadmin -H localhost declare queue name=realsearch.data.delete.queue auto_delete=false durable=true
rabbitmqadmin -H localhost declare queue name=realsearch.data.update.queue auto_delete=false durable=true
rabbitmqadmin -H localhost declare queue name=realsearch.data.audit.queue auto_delete=false durable=true
