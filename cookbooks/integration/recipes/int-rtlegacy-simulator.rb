#
# Cookbook Name:: integration
# Recipe:: int-rtlegacy-simulator
#
# Copyright 2014, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-rtlegacy-simulator"
app_version = node[:intrtl_sim_version]
version_str = "intrtl_sim_version"

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
amqp_host = node[:amqphost]
amqp_port = node[:amqpport]

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

# Integration elements pulled from data bag.
begin
  amqpcred = data_bag_item("rabbitmq", "realtrans")
    rescue Net::HTTPServerException
      raise "Error trying to load rabbitmq credentials from rabbitmq data bag."
end
amqp_user,amqp_pass = amqpcred['user'].split(" ").first.split("|")


template "/opt/tomcat/conf/rtlegacy.simulator.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
     :amqp_host => amqp_host,
     :amqp_port => amqp_port,
     :amqp_user => amqp_user,
     :amqp_pass => amqp_pass,
     :amqp_vhost => node[:realtrans_amqp_vhost],
     :amqp_heartbeat => node[:int_rtlegacy_simulator][:amqp][:heartbeat],
     :legacy_user => node[:int_rtlegacy_simulator][:legacy_user],
     :legacy_password => node[:int_rtlegacy_simulator][:legacy_password]
  )
  notifies :restart, resources(:service => "altitomcat")
end

