#
# Cookbook Name:: rsng
# Recipe:: replication-app
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "replication-app"
app_version = node[:repapp_version]

include_recipe "altisource::altitomcat"

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:rsng\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:repapp_version]
      node.set[:repapp_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end


if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
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
melissadata = data_bag_item("integration", "melissadata")
mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
rsngamqp = data_bag_item("rabbitmq", "realservice")
rsngcred = rsngamqp['user'].split("|")
template "/opt/tomcat/conf/replication-app.properties" do
  source "replication-app.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables( 
    :webHostname => webHost["rsng#{node.chef_environment}"],
    :melissadata => melissadata['melissadata'],
    :amqphost => "#{rsngcred[0]}",
    :amqpport => "#{rsngcred[1]}",
    :rsnghost => "#{rsnghost}:#{rsngport}",
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

