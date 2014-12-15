#
# Cookbook Name:: rf_iam_mysql
# Attributes:: default
#

# MySQL attribute defaults
#
default['mysql']['version'] = "5.6"
default['mysql']['port'] = "3306"
default['mysql']['data_dir'] = '/u02/mysqldata1/data/3306'
default['mysql']['server_root_password'] = "realmysql"
default['mysql']['server_repl_password'] = 'replmysql'
default['mysql']['allow_remote_root'] = true
default['mysql']['remove_anonymous_users'] = false
default['mysql']['remove_test_database'] = false

# MySQL-Multi attribute defaults
#
default['mysql-multi']['slave_user'] = 'repl'
default['mysql-multi']['server_repl_password'] = "#{node['mysql']['server_repl_password']}"

default['mysql-multi']['templates']['user.my.cnf']['cookbook'] = 'rf-iam-mysql'
default['mysql-multi']['templates']['user.my.cnf']['source'] = 'rf.user.my.cnf.erb'
default['mysql-multi']['templates']['my.cnf']['cookbook'] = 'rf-iam-mysql'
default['mysql-multi']['templates']['my.cnf']['source'] = 'rf.my.cnf.erb'
default['mysql-multi']['templates']['slave.cnf']['cookbook'] = 'rf-iam-mysql'
default['mysql-multi']['templates']['slave.cnf']['source'] = 'rf.slave.cnf.erb'
default['mysql-multi']['templates']['master.cnf']['cookbook'] = 'rf-iam-mysql'
default['mysql-multi']['templates']['master.cnf']['source'] = 'rf.master.cnf.erb'

# RF-IAM-MySQL attribute defaults
#
default['rf-iam-mysql']['user_mysql_pwd'] = "mysql"
default['rf-iam-mysql']['dbname'] = "rfng_iam"
default['rf-iam-mysql']['dbuser_iam'] = "rfng_iam_user"
default['rf-iam-mysql']['dbuser_iam_pwd'] = "awd37jk"

# Storage options
default['rf-iam-mysql']['storage']['data'] = '/u02/mysqldata1/data'
default['rf-iam-mysql']['storage']['innodb'] = '/u02/mysqldata1/innodb'
default['rf-iam-mysql']['storage']['mysqllog'] = '/u02/mysqldata/mysqllog'
default['rf-iam-mysql']['storage']['tmp'] = '/u02/mysqldata/tmp'
default['rf-iam-mysql']['storage']['backup'] = '/u03/mysqldata'

default['rf-iam-mysql']['auto-increment-offset'] = 1