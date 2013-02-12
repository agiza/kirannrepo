#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
volumes = "sdb|data|u02/mysqldata1/data sdc|innodb|u02/mysqldata1/innodb sdd|mysqllog|u02/mysqldata/mysqllog sde|tmp|u02/mysqldata/tmp sdf|backup|u03/mysqldata"
include_recipe "altisource::volgrp"

