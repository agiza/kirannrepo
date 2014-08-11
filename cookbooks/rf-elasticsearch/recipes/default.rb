#
# Cookbook Name:: rf-elasticsearch
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#

%w[ /usr/local/var /usr/local/var/data /usr/local/var/logs /usr/local/var/data/elasticsearch /usr/local/var/logs/elasticsearch].each do |path|
directory path do
    owner "root"
    group "root"
    mode  00777
  end
end

# create data and logs filesystems

execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvdn"
   # only if it's not mounted already
   not_if "grep -qs /dev/xvdn /proc/mounts"
end

execute 'mkfs' do
  command "mkfs -t ext4 /dev/xvdo"
# only if it's not mounted already
   not_if "grep -qs /dev/xvdo /proc/mounts"
end
 


mount "/usr/local/var/data/elasticsearch" do
  device "/dev/xvdn"
  fstype "ext4"
  options "rw"
  action [:mount,:enable]
end

mount "/usr/local/var/logs/elasticsearch" do
  device "/dev/xvdo"
  fstype "ext4"
  options "rw"
  action [:mount,:enable]
end

node.override["elasticsearch"]["version"] = "1.1.1"
node.override["elasticsearch"]["download_url"] = "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.tar.gz"
node.override['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = "false"
node.override['elasticsearch']['discovery']['zen']['minimum_master_nodes'] = "1"
node.override['elasticsearch']['cluster']['name'] = "rf-realsearch"
node.override['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = '["rfint-search-es-srv1.altidev.net","rfint-search-es-srv2.altidev.net","rfint-search-es-srv3.altudev.net"]'



include_recipe "monit"
include_recipe "elasticsearch"
include_recipe "elasticsearch::plugins"

directory "/usr/local/elasticsearch/config/templates" do 
     mode 00755
     owner "root"
     group "root"
     action :create
end

template "/usr/local/elasticsearch/config/templates/auditing_template.json" do
   source "auditing_template.json.erb"
      mode 00775
      owner "root"
      group "root"
end

template "/usr/local/elasticsearch/config/templates/search_template.json" do
   source "search_template.json.erb"
    mode 00775
    owner "root"
    group "root"
end


template "/root/index_user_management_iam_auditing.sh" do
   source "index_user_management_iam_auditing.sh.erb"
    mode 00775
    owner "root"
    group "root"
end




template "/root/taskData.sh" do
   source "taskData.sh.erb"
    mode 00775
    owner "root"
    group "root"
end


package "mysql-connector-java" do
   action :install
end

execute "river-mongodb plugin" do
  command '/usr/local/elasticsearch/bin/plugin -install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.0'
   not_if do
     File.exists?("/usr/local/elasticsearch/plugins/river-mongodb")
   end
end

execute "head plugin install" do 
  command '/usr/local/elasticsearch/bin/plugin -install mobz/elasticsearch-head'
   not_if do
     File.exists?("/usr/local/elasticsearch/plugins/head")
   end
end

execute "river-mongodb plugin" do
  command '/usr/local/elasticsearch/bin/plugin -install jdbc --url http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/1.1.0.2/elasticsearch-river-jdbc-1.1.0.2-plugin.zip'
   not_if do
     File.exists?("/usr/local/elasticsearch/plugins/jdbc")
   end
end

execute "copy mysql connector jar" do 
   command 'cp /usr/share/java/mysql-connector-java-5.1.17.jar /usr/local/elasticsearch/plugins/jdbc/'
end

yum_package "elasticsearch-scheduler-plugin" do 
    action :upgrade
end


include_recipe "elasticsearch::monit"

service "elasticsearch" do 
   action :start
end

include_recipe "iptables::disabled"


execute "Index script" do 
   command 'sleep 20s;root/index_user_management_iam_auditing.sh'
end

execute "TaskData script" do
   command '/root/taskData.sh'
end

service "elasticsearch" do
   action :restart
end

