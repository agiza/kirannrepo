#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
node.default.volumes = "sdb|data|u02/mysqldata1/data|defaults sdc|innodb|u02/mysqldata1/innodb|defaults sdd|mysqllog|u02/mysqldata/mysqllog|defaults sde|tmp|u02/mysqldata/tmp|defaults sdf|backup|u03/mysqldata|defaults"
include_recipe "altisource::volgrp"

