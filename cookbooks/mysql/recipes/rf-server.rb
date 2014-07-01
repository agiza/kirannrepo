#
# Cookbook Name:: mysql
# Recipe:: server
#
# Copyright 2008-2013, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
  password "mysql"
end

%w[ /u02 /u02/mysqldata1 /u02/mysqldata1/data /u02/mysqldata1/innodb].each do |path|
directory path do
    owner "mysql"
    group "mysql"
    mode  00755
  end
end
 
mount "/u02/mysqldata1/data" do
   device "/dev/xvdm"
   fstype "ext4"
   options "rw"
   action [:mount,:enable]
end

mount "/u02/mysqldata1/innodb" do
   device "/dev/xvdn"
   fstype "ext4"
   options "rw"
   action [:mount,:enable]
end

directory "/u02/mysqldata1/data/3306" do
    owner "mysql"
    group "mysql"
    mode  00755
    action :create
end

%w[ /u02/mysqldata1/innodb/3306 /u02/mysqldata1/innodb/3306/data /u02/mysqldata1/innodb/3306/log ].each do |path|
directory path do
    owner "mysql"
    group "mysql"
    mode  00755
  end
end


%w[ /u03 /u03/mysqldata /u03/mysqldata/backup ].each do |path|
directory path do
    owner "mysql"
    group "mysql"
    mode  00755
  end
end

mount "/u03/mysqldata/backup" do
   device "/dev/xvdq"
   fstype "ext4"
   options "rw"
   action [:mount,:enable]
end

%w[ /u02/mysqldata /u02/mysqldata/mysqllog  /u02/mysqldata/tmp ].each do |path|
directory path do
    owner "mysql"
    group "mysql"
    mode  00755
  end
end


mount "/u02/mysqldata/mysqllog" do
   device "/dev/xvdo"
   fstype "ext4"
   options "rw"
   action [:mount,:enable]
end

mount "/u02/mysqldata/tmp" do
   device "/dev/xvdp"
   fstype "ext4"
   options "rw"
   action [:mount,:enable]
end

%w[ /u02/mysqldata/mysqllog/3306  /u02/mysqldata/mysqllog/3306/err /u02/mysqldata/mysqllog/3306/general /u02/mysqldata/mysqllog/3306/bin /u02/mysqldata/mysqllog/3306/relay ].each do |path|
directory path do
    owner "mysql"
    group "mysql"
    mode  00755
  end
end



node.override['mysql']['server_root_password'] = 'realmysql'
node.override['mysql']['port'] = '3308'
node.override['mysql']['data_dir'] = '/u02/mysqldata1/data/3306'
node.override['mysql']['mysql_service'] = 'mysql'
node.override['mysql']['package_name'] = 'MySQL-server-advanced'


yum_package "MySQL-client-advanced" do
    action :upgrade
end

yum_package "MySQL-shared-compat-advanced" do
    action :upgrade
end

yum_package "MySQL-devel-advanced" do
    action :upgrade
end

yum_package "MySQL-shared-advanced" do
    action :upgrade
end

yum_package "MySQL-embedded-advanced" do
    action :upgrade
end

node.override['mysql']['server_root_password'] = 'realmysql'
node.override['mysql']['port'] = '3308'
node.override['mysql']['data_dir'] = '/u02/mysqldata1/data/3306'
node.override['mysql']['mysql_service'] = 'mysql'
node.override['mysql']['package_name'] = 'MySQL-server-advanced'
node.override['mysql']['template_source'] = 'rf-my.cnf.erb'



mysql_service node['mysql']['mysql'] do
  version node['mysql']['version']
  port node['mysql']['port']
  data_dir node['mysql']['data_dir']
  server_root_password node['mysql']['server_root_password']
  server_debian_password node['mysql']['server_debian_password']
  server_repl_password node['mysql']['server_repl_password']
  allow_remote_root node['mysql']['allow_remote_root']
  remove_anonymous_users node['mysql']['remove_anonymous_users']
  remove_test_database node['mysql']['remove_test_database']
  root_network_acl node['mysql']['root_network_acl']
  version node['mysql']['version']
  action :create
end

template '/etc/my.cnf' do
  owner 'mysql'
  owner 'mysql'
  source 'rf-my.cnf.erb'
end

