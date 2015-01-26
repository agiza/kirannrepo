#
# Cookbook Name:: rf-iam-mysql
# Recipe:: rf-base
#
# Copyright 2014, Altisource Labs, Inc
#
# All rights reserved - Do Not Redistribute
#

template "/root/create_rfiamdb.sql" do
  source "create_rfiamdb.sql.erb"
  mode  00775
  owner "root"
  group "root"
end

template "/root/create_rfiamuser.sql" do
  source "create_rfiamuser.sql.erb"
  mode  00775
  owner "root"
  group "root"
end

template "/etc/security/limits.conf" do
  source "limits.conf.erb"
  mode 00600
  owner "root"
  group "root"
end

cookbook_file "/u02/mysqldata/dba/scripts/shell/mysql_binlog_backup.sh" do
  source "mysql_binlog_backup.sh"
  mode  00755
  owner "mysql"
  group "mysql"
end

cookbook_file "/u02/mysqldata/dba/scripts/shell/mysql_database_backup.sh" do
  source "mysql_database_backup.sh"
  mode  00755
  owner "mysql"
  group "mysql"
end

cookbook_file "/u02/mysqldata/dba/scripts/shell/start_mysql_3306.sh" do
  source "start_mysql_3306.sh"
  mode  00755
  owner "mysql"
  group "mysql"
end

execute "initialize real db" do
  command "cd /root;/usr/bin/mysql -u root --password=#{node['mysql']['server_root_password']} < create_rfiamdb.sql"
end

execute "initialize IAM user" do
  command "cd /root;/usr/bin/mysql -u root --password=#{node['mysql']['server_root_password']} < create_rfiamuser.sql"
end