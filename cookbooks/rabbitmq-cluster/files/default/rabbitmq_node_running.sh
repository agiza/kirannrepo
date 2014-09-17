#This is node used anymore
#!/bin/bash

STATUS=`rabbitmqctl -n rabbit@$1 status`
echo $STATUS
if grep -q amqp_client <<<$STATUS
then
    echo 'This node is running!';
    exit 0;
else
    echo 'This node is not running!';
    exit 1;
fi