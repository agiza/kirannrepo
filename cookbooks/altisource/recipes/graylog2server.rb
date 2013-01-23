#
# Cookbook Name:: altisource
# Recipe:: graylog2server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::epel"
include_recipe "altisource::passenger"
include_recipe "altisource::10gen"

graylog=data_bag_item("infrastructure", "graylog2")
version=graylog['graylog_version']

package "lsb gcc make rubygems.noarch ruby-devel mod_passenger" do
  action :install
end

package "mongo-10-gen-server java-1.7.0-openjdk" do
  action :upgrade
end

package "elasticsearch" do
  action :upgrade
end

service "mongod" do
  supports :stop => true, :start => true, :reload => true, :restart => true
  action :nothing
end

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

package "openjdk openssl-devel zlib-devel gcc gcc-c++ make autoconf readline-devel curl-devel expat-devel gettext-devel" do
  action :upgrade
end

execute "grayloguser" do
  command "echo -e 'use graylog2 \r db.addUser('graylog2user','graylog2pass')\r db.auth('graylog2user','graylog2pass')\r' < sudo mongo; touch /var/log/graylog2mongo"
  user "mongod"
  action :run
  creates "/var/log/graylog2mongo"
end

if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = {}
  search(:node, 'recipes:infrastructure\:\:yumserver') do |n|
    yumserver[n.ipaddress] = {}
  end
end
yumserver = yumserver.first
execute "graylogdownload" do
  command "wget -O /tmp/graylog2-server-#{version}.tar.gz http://yumserver/common/graylog2-server-#{version}.tar.gz; wget -O /tmp/graylog2-web-interface-#{version}.tar.gz http://yumserver/common/graylog2-web-interface-#{version}.tar.gz"
  creates "/tmp/graylog2-server-#{version}.tar.gz"
  action :nothing
end

execute "graylogextract" do
  command "cp /tmp/graylog2-server-#{version}.tar.gz /opt/; cp /tmp/graylog2-web-interface-#{version}.tar.gz /opt/;cd /opt/; tar -xzvf graylog2-server-#{version}.tar.gz; tar -xzvf /tmp/graylog2-web-interface-#{version}.tar.gz"
  creates "/opt/graylog2"
  action :nothing
end

service "graylog2" do
  supports :stop => true, :start => true, :reload => true, :restart => true
  action :nothing
end

splunkindexes = data_bag_item("splunk_index", "indexes")
splunk_indexes = splunkindexes['indexes'].split(',')
template "/opt/splunk/etc/apps/search/local/indexes.conf" do
  source "server.indexes.conf.erb"
  owner  "root"
  group  "root"
  mode   "0600"
  variables(
    :splunk_indexes => splunk_indexes
  )
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/system/local/server.conf" do
  source "server.server.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/apps/search/local/inputs.conf" do
  source "server.inputs.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/system/local/web.conf" do
  source "server.web.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

template "/opt/splunk/etc/system/local/inputs.conf" do
  source "server.inputs.local.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "splunk")
end

service "mongod" do
  supports :stop => true, :start => true, :reload => true, :restart => true
  action [:enable, :start]
end

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end

service "graylog2" do
  action [:enable, :start]
end

