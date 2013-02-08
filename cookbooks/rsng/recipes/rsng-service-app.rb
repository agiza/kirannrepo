#
# Cookbook Name:: rsng
# Recipe:: rsng-service-app
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "rsng-service-app"
app_version = node[:rsngapp_version]

include_recipe "altisource::altitomcat"
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.info("No services returned from search.")
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
end

if node.attribute?('rsngproxy')
  rsnghost = node[:rsngproxy].split(":")[0]
  rsngport = node[:rsngproxy].split(":")[1]
else
  rsnghost = search(:node, "recipes:rsng\\:\\:rsng-service-app OR role:realservicing AND chef_environment:#{node.chef_environment}")
  if rsnghost.nil? || rsnghost.empty?
    Chef::Log.info("No services returned from search.")
  else
    rsnghost = rsnghost.first
    rsnghost = rsnghost["ipaddress"]
    rsngport = "8080"
  end
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

webHost = data_bag_item("infrastructure", "apache")
rsngamqp = data_bag_item("rabbitmq", "realservice")
rsngcred = rsngamqp['user'].split("|")
mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
melissadata = data_bag_item("integration", "melissadata")
template "/opt/tomcat/conf/rsng-service-app.properties" do
  source "rsng-service-app.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables( 
    :webHostname => webHost["rsng#{node.chef_environment}"],
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rsngcred[0]}",
    :amqppass => "#{rsngcred[1]}",
    :rsnghost => "#{rsnghost}:#{rsngport}",
    :melissadata => melissadata['melissadata'],
    :mysqldb => mysqldb["realservice"]
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb["realservice"])
  notifies :restart, resources(:service => "altitomcat")
end

