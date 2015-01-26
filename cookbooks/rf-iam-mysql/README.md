rf-iam-mysql Cookbook
=====================
Chef wrapper cookbook to 
1. Creates master/slave MySQL server setup
2. Sets up storage structure according to Altisource standards
3. Creates an empty IAM database = rfng_iam
4. Creates IAM user to be used within IAM application
5. Creates MySQL master-master replication
6. Creates MySQL HAProxy load-balancer configuration

This cookbook is tested on RHEL platform (CentOS 6.5)    

Requirements
------------
Use the cookbook, either 1) configuration, or 2), never both in the same time.
1) This cookbook should run in conjunction with `rf-iam-liquibase`, which populates IAM database with seed data.
Depends on `mysql-multi` & `mysql` community cookbooks.
2)To be used for HAProxy MySQL configuration

Utilization
------------
Cookbook works as a wrapper for installing IAM database on community MySQL server. 

The cookbook utilizes three recipes depending on the server's role.

`rf-master.rb` : sets up master MySQL server and creates replicant users for each slave node defined within attributes. 

`rf-slave.rb` : sets up a slave MySQL server pointing to the master node defined within attributes.

`rf-default` : setups a MySQL server instance without any replications setup

`rf-storage` : sets up storage locations for MySQL installation. Recipe only creates necessary folder structure. 
Mounting drives should be done outside of this recipe. Used internally from rf-master & rf-slave

`rf-base` : installs IAM database, created IAM user for access, copies DBA scripts. 
Used internally from rf-master & rf-slave.


Attributes
----------

# mysql attribute defaults

`['mysql']['version']` : MySQL version that needs to be installed. Defaults to `5.6` for IAM.

`['mysql']['port']` : Default port for mysqld service to listen on. Defaults to `3306`.

`['mysql']['data_dir']` : Defaults to '/u02/mysqldata1/data/3306'

`['mysql']['server_root_password']` : set root password

`['mysql']['server_repl_password']` : password for replication user

# mysql-multi attribute defaults

`['mysql-multi']['slave_user']` : Default to user `repl`

`['mysql-multi']['server_repl_password']` : Set the value to match `['mysql']['server_repl_password']`. 
By default the value is copied from the node attribute


# rf-iam-mysql attribute defaults

`['rf-iam-mysql']['user_mysql_pwd']` : Password for `mysql` user on target system. 

`['rf-iam-mysql']['dbname']` : IAM database name. Defaults to `rfng_iam`

`['rf-iam-mysql']['dbuser_iam']` : User to access IAM database. Defaults to `rfng_iam_user`

`['rf-iam-mysql']['dbuser_iam_pwd']` : Password for IAM user.

# Storage options

`['rf-iam-mysql']['storage']['data']` = '/u02/mysqldata1/data/3306'

`['rf-iam-mysql']['storage']['innodb']` = '/u02/mysqldata1/innodb/3306'

`['rf-iam-mysql']['storage']['mysqllog']` = '/u02/mysqldata/mysqllog/3306'

`['rf-iam-mysql']['storage']['tmp']` = '/u02/mysqldata/tmp'

`['rf-iam-mysql']['storage']['backup']` = '/u03/mysqldata'

`['rf-iam-mysql']['auto-increment-increment']` : Defaults to '10'

`['rf-iam-mysql']['auto-increment-offset']` :  Defaults to 1.
Use one of the value from [0123]. Use even numbers for the masters and odd numbers for the slaves. 

# MySQL master-master 

['rf-iam-mysql']['m_m_host_ip']    :  default to '127.0.0.1' and is the 'bind-address' from my.cnf; replace with machine real IP, so MySQL accepts connections from LAN/Internet

['rf-iam-mysql']['masterhost']     :  default to '127.0.0.1', but needs to be filled in with the IP of the other Master machine

['rf-iam-mysql']['masterpassword'] :  defaults to 'password'; is the master of the 'replicator' user

['rf-iam-mysql']['masterlogfile']  :  defaults to a unreal value 'mysql-bin.000001'. After executing on the other master machine at mysql shell: "show master status", bring the real value from "File" column in the table shown

['rf-iam-mysql']['masterlogpos']   :  defaults to a unreal value 120. After executing on the other master machine at mysql shell: "show master status", bring the real value from "Position" column in the table shown

# MySQL HAProxy

['rf-iam-mysql']['masterhost1'] 	: defaults to '127.0.0.1'. It's the IP of MySQL server droplet 1

['rf-iam-mysql']['masterhost2'] 	: defaults to '127.0.0.1'. It's the IP of MySQL server droplet 2

['rf-iam-mysql']['hacheck'] 		: defaults to 'haproxycheck' string. It is used by HAProxy service to check the status of the MySQL servers.

['rf-iam-mysql']['harootuser'] 		: defaults to 'haproxyroot' string. It's for a MySQL user is needed with root privileges for accessing the MySQL m-m from HAProxy

['rf-iam-mysql']['harootpassword']  : defaults to 'password' string. It's the password of HAProxyRoot user

['rf-iam-mysql']['maxconn'] 		: defaults to 4096. Specifies the no of concurrent connections on the frontend. Can be tuned anyhow

['rf-iam-mysql']['connect'] 		: defaults to 5s. Specifies the maximum time to wait for a connection to succeed.

['rf-iam-mysql']['client'] 			: defaults to 10s. Specifies client timeout applied for ACK during TCP connection.

['rf-iam-mysql']['server']			: defaults to 10s. Specifies server timeout applied for sending during TCP connection

['rf-iam-mysql']['retries']			: defaults to 3. Specifies the  no of retries to perform  

Usage
-----
#### rf-iam-mysql::rf-master
Change the value of `['rf-iam-mysql']['auto-increment-offset']` to even number 0 or 2
Include this recipe in your run list, if you want to have MySQL Server acting as master.
Recipe will not work if there are 1 or more MYSQL master's already available in the same environment 

#### rf-iam-mysql::rf-master-patch
Include this recipe in your run list, if you want to have MySQL master-master replication fully functional.
#### rf-iam-mysql::rf-slave
Change the value of `['rf-iam-mysql']['auto-increment-offset']` to odd number 1 or 3
Include this recipe in your run list, if you want to have MySQL Server acting as slave.
This will work only if there is one Master available in your current environment

#### rf-iam-mysql
Include this recipe in your run list, if you want to have standard MySQL Server. No replication is set.

#### rf-mysqlhaproxy
Include this recipe if you need haproxy service running over a MySQL master-master replication setup
License and Authors
-------------------
Authors: Thanooj Kamavarapu(thanooj.kamavarapu@altisource.com)
