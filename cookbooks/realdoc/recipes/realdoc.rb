#
# Cookbook Name:: realdoc
# Recipe:: realdoc
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realdoc"
app_version = node[:realdoc_version]

include_recipe "altisource::altitomcat"
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver AND chef_environment:shared")
  amqphost = amqphost[:ipaddress]
  amqphost = amqphost.first
  amqpport = "5672"
end
if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
  rdochost = rdochost[:ipaddress]
  rdochost = rdochost.first
  rdocport = "8080"
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall')
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

package "msttcorefonts" do
  action :upgrade
end

mongoHost = "127.0.0.1"
if node.attribute?('elasticsearchproxy')
  elasticHost = node[:elasticsearchproxy]
else
  elasticHost = search(:node, "recipes:elasticsearch\\:\\:elasticsearch AND chef_environment:#{node.chef_environment}")
  elasticHost = elasticHost[:ipaddress]
end

# Integration components
webHost = data_bag_item("infrastructure", "apache")
rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split(" ").first.split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
ftpserver = data_bag_item("integration", "realdoc")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["rd#{node.chef_environment}"],
    :mongo_host => "#{mongoHost}",
    :elastic_host => "#{elasticHost}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rdrabbit[0]}",
    :amqppass => "#{rdrabbit[1]}",
    :rdochost => "#{rdochost}:#{rdocport}",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver,
    :ldapserver => ldapserver,
    :ftpserver => ftpserver
  )
end

mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "realdoc.xml.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  variables(:mysqldb => mysqldb["#{app_name}"])
  notifies :restart, resources(:service => "altitomcat")
end

directory "/opt/tomcat/correspondence" do
  owner "tomcat"
  group "tomcat"
end

directory "/opt/tomcat/correspondence/input" do
  owner "tomcat"
  group "tomcat"
end

template "/opt/tomcat/conf/realdoc.key" do
  source "realdoc.key.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0600"
end

