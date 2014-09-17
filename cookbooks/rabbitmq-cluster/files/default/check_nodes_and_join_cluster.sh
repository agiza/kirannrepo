#This is node used anymore
#!/bin/bash
arr=$(echo $1 | tr " " "\n")

for var in $arr
do
    STATUS=`rabbitmqctl -n rabbit@$var status`
    echo $STATUS
    if grep -q amqp_client <<<$STATUS
    then
        echo 'This node is running!';
        statusRes=0;
    else
        echo 'This node is not running!';
        statusRes=1;
    fi

    if [[ $statusRes == 0 ]]
    then
        echo "Joining cluster with RabbitMQ node on $var";
        rabbitmqctl stop_app
        rabbitmqctl join_cluster rabbit@$var
        rabbitmqctl start_app
        res=0
    else
        echo "Not Joining cluster with RabbitMQ node on $var"
        res=1
    fi
    if [[ $res == 0 ]]
    then
        break;
    fi
done
