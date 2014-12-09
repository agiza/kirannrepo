#
# Cookbook Name:: rf-iam-mysql
# Recipe:: rf-storage
#
# Copyright 2014, Altisource Labs, Inc
#
# All rights reserved - Do Not Redistribute
#

group "mysql" do
  gid "495"
  action :create
end

user "mysql" do
  supports :manage_home => true
  comment "Mysql User"
  uid "496"
  gid "mysql"
  home "/home/mysql"
  shell "/bin/bash"
  password "#{node['rf-iam-mysql']['user_mysql_pwd']}"
end

%w[ /u02
    /u02/mysqldata1
    /u02/mysqldata1/data
    /u02/mysqldata1/data/3306 ].each do |path|
  directory path do
    owner 'mysql'
    group 'mysql'
    mode  '0775'
    action :create
  end
end

%w[ /u02/mysqldata1/innodb
    /u02/mysqldata1/innodb/3306
    /u02/mysqldata1/innodb/3306/data
    /u02/mysqldata1/innodb/3306/log ].each do |path|
  directory path do
    owner 'mysql'
    group 'mysql'
    mode  '0775'
    action :create
  end
end

%w[ /u02/mysqldata
    /u02/mysqldata/mysqllog
    /u02/mysqldata/tmp
    /u02/mysqldata/dba ].each do |path|
  directory path do
    owner 'mysql'
    group 'mysql'
    mode  '0775'
    action :create
  end
end

%w[ /u02/mysqldata/mysqllog/3306
    /u02/mysqldata/mysqllog/3306/bin
    /u02/mysqldata/mysqllog/3306/err
    /u02/mysqldata/mysqllog/3306/general
    /u02/mysqldata/mysqllog/3306/relay
    /u02/mysqldata/mysqllog/3306/slow ].each do |path|
  directory path do
    owner 'mysql'
    group 'mysql'
    mode  '0775'
    action :create
  end
end

%w[ /u02/mysqldata/dba/conf
    /u02/mysqldata/dba/log
    /u02/mysqldata/dba/scripts
    /u02/mysqldata/dba/scripts/perl
    /u02/mysqldata/dba/scripts/shell ].each do |path|
  directory path do
    owner 'mysql'
    group 'mysql'
    mode  '0775'
    action :create
  end
end

%w[ /u03
    /u03/mysqldata
    /u03/mysqldata/backup
    /u03/mysqldata/backup/3306 ].each do |path|
  directory path do
    owner 'mysql'
    group 'mysql'
    mode  '0775'
    action :create
  end
end
