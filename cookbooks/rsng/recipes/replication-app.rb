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

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty? || app_version == "0.0.0-1"
    new_version = search(:node, "repapp_version:* AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      version_string = []
      new_version.each do |version|
        version_string << version["repapp_version"]
      end
      new_version = version_string.sort.uniq.last
      app_version = new_version
      node.set[:repapp_version] = app_version
    end
    if app_version = "0.0.0-1"
      Chef::Log.fatal("Version is still the default version, please assign a current version of this software package.")
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

projour = Chef::DataBag.load("infrastructure")
if projour["projourdb#{node.chef_environment}"]
  projourdb = data_bag_item("infrastructure", "projourdb#{node.chef_environment}")
else
  projourdb = data_bag_item("infrastructure", "projourdb")
end

mysql = Chef::DataBag.load("infrastructure")
if mysql["mysqldb#{node.chef_environment}"]
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
else
  mysqldb = data_bag_item("infrastructure", "mysqldb")
end
webHost = data_bag_item("infrastructure", "apache")
melissadata = data_bag_item("integration", "melissadata")
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
    :amqpuser => "#{rsngcred[0]}",
    :amqppass => "#{rsngcred[1]}",
    :rsnghost => "#{rsnghost}:#{rsngport}",
    :amqphost => amqphost,
    :amqpport => amqpport,
    :mysqldb => mysqldb["realservice"],
    :projourdb => projourdb["realservice"]
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

