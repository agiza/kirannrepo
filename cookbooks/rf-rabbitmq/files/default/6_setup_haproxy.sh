#!/bin/bash

#Run this script from the machine on which you are installing

echo 'Installing haproxy'
sudo yum install haproxy

#Copy the config file - no command for this, I copied manually

service haproxy start
chkconfig haproxy on

