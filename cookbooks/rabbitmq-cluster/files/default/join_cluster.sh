#This is node used anymore
#!/bin/bash

sh rabbitmq_node_running_modified.sh $1
res=$?
if [[ $res == 0 ]]
then
    echo "Joining cluster with RabbitMQ node on $1";
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@$1
    rabbitmqctl start_app
    exit 0
else
    echo "Not Joining cluster with RabbitMQ node on $1"
    exit 1
fi