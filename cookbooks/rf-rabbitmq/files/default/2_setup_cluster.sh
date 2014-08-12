#!/bin/bash

#Run this script from the machine on which you are installing

#Choose a master node
#Make sure that all other nodes share the same cookie
#Because of nexus and not able to scp the cookie between AWS machines due to ssh keys and permission denied stuff
#I manually edited the cookies from all the nodes to match the one from the master

#Copy the cookie everywhere
echo 'Copying erlang cookies'
sudo cp -f /var/lib/rabbitmq/.erlang.cookie /root/.erlang.cookie
sudo cp -f /var/lib/rabbitmq/.erlang.cookie /home/rabbitmq/.erlang.cookie

