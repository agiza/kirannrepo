#
# Cookbook Name:: rf-slave 
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
execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvdn"
   # only if it's not mounted already
   not_if "grep -qs /dev/xvdn /proc/mounts"
end

execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvdp"
   #only if it's not mounted already
    not_if "grep -qs /dev/xvdp /proc/mounts"
end
   
execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvdq"
   # only if it's not mounted already
   not_if "grep -qs /dev/xvdq /proc/mounts"
end

execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvdr"
   # only if it's not mounted already
   not_if "grep -qs /dev/xvdr /proc/mounts"
end

execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvds"
    # only if it's not mounted already
   not_if "grep -qs /dev/xvds /proc/mounts"
end 




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
   device "/dev/xvdn"
   fstype "ext4"
   options "rw"
   action [:mount,:enable]
end

mount "/u02/mysqldata1/innodb" do
   device "/dev/xvdp"
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
   device "/dev/xvdr"
   fstype "ext4"
   options "rw"
   action [:mount,:enable]
end

mount "/u02/mysqldata/tmp" do
   device "/dev/xvds"
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

yum_package "MySQL-server-advanced" do
    action :upgrade
end

template "/etc/my.cnf" do
  source "/rf-slave-my.cnf.erb"
  mode  00775
  owner "mysql"
  group "mysql"
end

template "/etc/security/limits.conf" do 
   source "limits.conf.erb"
     mode 00600
     owner "root"
     group "root"
end

execute "clean up ownership" do
  command "chown -R mysql:mysql /u02"
end

execute "install initial DB" do
    command "mysql_install_db --defaults-file=/etc/my.cnf --user=mysql --basedir=/usr --datadir=/u02/mysqldata1/data/3306 --explicit_defaults_for_timestamp --keep > /tmp/mysql.log"
    not_if { ::File.exists?("/tmp/mysql.log")}
end

execute "start MYSQL service" do
    command "/etc/init.d/mysql start"
end

execute "install root password" do
   command "/usr/bin/mysqladmin -u root password 'realmysql'"
end


