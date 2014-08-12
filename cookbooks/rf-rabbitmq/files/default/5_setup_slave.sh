#!/bin/bash

HOSTNAME=$1

echo "Joining cluster with RabbitMQ node on $HOSTNAME"
rabbitmq-server -detached
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@${HOSTNAME}
rabbitmqctl start_app
