#!/bin/bash

#Before copy the cookies
#The rabbitmq server should be on

rabbitmqctl set_policy realsearch.data.policy "realsearch\.data" '{"ha-mode":"all"}'
