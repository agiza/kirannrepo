#!/bin/bash
#Script that will add in the /etc/hosts a new entry if it doesn't exists already
#first parameter is the ip, second parameter is the hostName
grep -q $1' '$2 /etc/hosts || echo $1' '$2 >> /etc/hosts
