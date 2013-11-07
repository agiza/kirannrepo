#
# Cookbook Name:: realtrans
# Recipe:: realtrans-rp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realtrans-rp"
app_version = node[:realtransrp_version]
version_str = "realtransrp_version"

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty? || app_version == "0.0.0-1"
    new_version = search(:node, "#{version_str}:* AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.info("No version for #{app_name} software package found.")
    else
      version_string = []
      new_version.each do |version|
        version_string << version["#{version_str}"]
      end
      new_version = version_string.sort.uniq.last
      app_version = new_version
      node.set["#{version_str}"] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

include_recipe "realtrans::default"
rdochost = node[:rdochost]
rdocport = node[:rdocport]

rtcenhost = node[:rtcenhost]
rtcenport = node[:rtcenport]

amqphost = node[:amqphost]
amqpport = node[:amqpport]

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed for version is still invalid default.")
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

# Integration components
webHost = data_bag_item("infrastructure", "apache")
rtrabbit = data_bag_item("rabbitmq", "realtrans")
rtrabbit = rtrabbit['user'].split(" ").first.split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
# Internal/External names (if configured)
internalName = webHost["rt#{node.chef_environment}"]
externalName = webHost["rte#{node.chef_environment}"]
if externalName.nil? || externalName.empty?
	externalName = internalName
end
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => internalName,
    :extHostname => externalName,
    :realdoc_hostname => "#{rdochost}:#{rdocport}",
    :rt_cen_host => "#{rtcenhost}:#{rtcenport}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rtrabbit[0]}",
    :amqppass => "#{rtrabbit[1]}",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver,
    :ldapserver => ldapserver,
    :maxfilesize => node[:realtrans][:logging][:maxfilesize],
    :maxfilehistory => node[:realtrans][:logging][:maxhistory] 

  )
end

mysql = Chef::DataBag.load("infrastructure")
if mysql["mysqldb#{node.chef_environment}"]
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
else
  mysqldb = data_bag_item("infrastructure", "mysqldb")
end
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb['realtrans'])
  notifies :restart, resources(:service => "altitomcat")
end
