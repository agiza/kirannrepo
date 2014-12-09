rf-iam-mysql Cookbook
=====================
Chef wrapper cookbook to 
1. create master/slave MySQL server setup
2. set up storage structure according to Altisource standards
3. create an empty IAM database.
4. Creates IAM user to be used within IAM application

This cookbook is tested on RHEL platform (CentOS 6.5)    

Requirements
------------
This cookbook should run in conjunction with `rf-iam-liquibase`, which populates IAM database with seed data.
Depends on `mysql-multi` & `mysql` community cookbooks.

Utilization
------------
Cookbook works as a wrapper for installing IAM database on community MySQL server. 

The cookbook utilizes three recipes depending on the server's role.

`rf-master.rb` : sets up a master MySQL server and creates replicant users 
for each slave node definded within attributes. 

`rf-slave.rb` : sets up a slave MySQL server pointing to the master node 
definded within attributes.

`rf-default` : setups a MySQL server instance without any replications setup

`rf-storage` : sets up storage locations for MySQL installation. Recipe only creates folder structure necessary. 
Mounting drives should be done outside of this recipe. Used internally from rf-master & rf-slave

`rf-base` : installs IAM database, created IAM user for access, copies DBA scripts. 
Used internally from rf-master & rf-slave.


Attributes
----------

# mysql attribute defaults

`['mysql']['version']` : MySQL version that needs to be installed. Defaults to `5.6` for IAM.

`['mysql']['port']` : Default port for mysqld service to listen on. Defaults to `3306`.

`['mysql']['data_dir']` : '/u02/mysqldata1/data/3306'

`['mysql']['server_root_password']` : set root password

`['mysql']['server_repl_password']` : password for replication user

# mysql-multi attribute defaults

`['mysql-multi']['slave_user']` : Default to user `repl`

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

`['rf-iam-mysql']['auto-increment-offset']` :  [0123] (0,1,2 or 3 depending on which instance you are on. 
Use even numbers for the masters and odd numbers for the slaves.) 


Usage
-----
#### rf-iam-mysql::rf-master
TODO: Write usage instructions for each cookbook.

License and Authors
-------------------
Authors: Thanooj Kamavarapu(thanooj.kamavarapu@altisource.com)
