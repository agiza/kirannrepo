#
# Cookbook Name:: rf-iam-mysql
# Recipe:: rf-master
#
# Copyright 2014, Altisource Labs, Inc
#
# All rights reserved - Do Not Redistribute
#

template "/root/create_haproxyusers.sql" do
	source "create_haproxyusers.sql.erb"
	mode 00775
	owner "root"
	group "root"
end

template "root/rf.allow-replication.sql" do
	source "rf.allow-replication.sql.erb"
	mode 00775
	owner "root"
	group "root"
end

execute "initialize replication" do
  command "cd /root;/usr/bin/mysql -u root --password=#{node['mysql']['server_root_password']} < create_haproxyusers.sql"
end

execute "initialize replication 2" do
  command "cd /root;/usr/bin/mysql -u root --password=#{node['mysql']['server_root_password']} < rf.allow-replication.sql"
end

service "mysqld" do
  action :restart
end
