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

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:rsng\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:rsngapp_version]
      node.set[:rsngapp_version] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

include_recipe "rsng::default"
amqphost = node[:amqphost]
amqpport = node[:amqpport]
rsnghost = node[:rsnghost]
rsngport = node[:rsngport]

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

