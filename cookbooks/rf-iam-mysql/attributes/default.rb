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

# HaProxy for MySQL
default['rf-iam-mysql']['serverid']     	= 1
default['rf-iam-mysql']['m_m_host_ip'] 		= '127.0.0.1'
default['rf-iam-mysql']['masterhost1'] 		= '127.0.0.1'
default['rf-iam-mysql']['masterhost2'] 		= '127.0.0.1'
default['rf-iam-mysql']['masterhost']  		= '127.0.0.1'
default['rf-iam-mysql']['masterpassword'] 	= 'password'
default['rf-iam-mysql']['masterlogfile'] 	= 'mysql-bin.000006'
default['rf-iam-mysql']['masterlogpos'] 	= 120
default['rf-iam-mysql']['hacheck'] 			= '127.0.0.1'
default['rf-iam-mysql']['harootuser'] 		= '127.0.0.1'
default['rf-iam-mysql']['harootpassword'] 	= 'password'
default['rf-iam-mysql']['retries']			= 3
default['rf-iam-mysql']['connect']  		= 5000
default['rf-iam-mysql']['client']			= 10000
default['rf-iam-mysql']['server']			= 10000
