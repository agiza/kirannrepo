#
# Cookbook Name:: integration
# Recipe:: int-realservicing
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-realservicing"
app_version = node[:intrs_version]
version_str = "intrs_version"

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

include_recipe "integration::default"
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

# Integration elements.
begin
  amqpcred = data_bag_item("rabbitmq", "realtrans")
    rescue Net::HTTPServerException
      raise "Error loading rabbitmq credentials from rabbitmq data bag."
end
amqpcred = amqpcred['user'].split(" ").first.split("|")
begin
  realservicing = data_bag_item("integration", "realservicing#{node.chef_environment}")
    rescue Net::HTTPServerException
      realservicing = data_bag_item("integration", "realservicing")
        rescue Net::HTTPServerException
          raise "Error loading realservicing information from integration data bag."
end
template "/opt/tomcat/conf/int-realservicing.properties" do
  source "int-realservicing.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :amqphost => amqphost,
    :amqpport => amqpport,
    :amqpuser => amqpcred[0],
    :amqppass => amqpcred[1],
    :maxfilesize => node[:integration][:realtrans][:logging][:maxfilesize],
    :maxhistory => node[:integration][:realtrans][:logging][:maxhistory],
    :realsvc => realservicing
  )
  notifies :restart, resources(:service => "altitomcat")
end

directory "/opt/tomcat/realservicing/response" do
  owner "tomcat"
  group "tomcat"
  recursive true
  action :create
end

