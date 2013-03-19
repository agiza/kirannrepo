#
# Cookbook Name:: integration
# Recipe:: int-corelogic
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-corelogic"
app_version = node[:intcorelogic_version]
version_str = "intcorelogic_version"

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

begin
  amqpcred = data_bag_item("rabbitmq", "l1")
    rescue Net::HTTPServerException
      raise "Error loading Rabbitmq credentials from rabbitmq data bag."
end
unless amqpcred.nil? || amqpcred.empty? do
  amqpcred = amqpcred['user'].split("|")
end
# Find environment specific data bag settings if they exist, if not roll back to simple data bag.
begin
  corelogic = data_bag_item("integration", "corelogic#{node.chef_environment}")
    rescue Net::HTTPServerException
      corelogic = data_bag_item("integration", "corelogic")
        rescue Net::HTTPServerException
          raise "Error loading corelogic information from integration data bag."
end
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{amqpcred[0]}",
    :amqppass => "#{amqpcred[1]}",
    :corepass => "#{corelogic['pass']}",
    :coreuser => "#{corelogic['user']}",
    :coreurl => "#{corelogic['neworderurl']}",
    :coretoken => "#{corelogic['authtoken']}"
  )
  notifies :restart, resources(:service => "altitomcat")
end

