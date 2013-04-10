#
# Cookbook Name:: integration
# Recipe:: int-realresolution
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-realresolution"
app_version = node[:intrres_version]
version_str = "intrres_version"

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

# Integration elements pulled from data bag.
begin
  amqpcred = data_bag_item("rabbitmq", "realtrans")
    rescue Net::HTTPServerException
      raise "Error trying to load rabbitmq credentials from rabbitmq data bag."
end
amqpcred = amqpcred['user'].split(" ")[0].split("|")
begin
  realsvc = data_bag_item("integration", "realservicing#{node.chef_environment}")
    rescue Net::HTTPServerException
      realsvc = data_bag_item("integration", "realservicing")
        rescue Net::HTTPServerException
          raise "Error loading realserving information from integration data bag."
end
begin
  realres = data_bag_item("integration", "realresolution#{node.chef_environment}")
  rescue Net::HTTPServerException
    realres = data_bag_item("integration", "realresolution")
    rescue Net::HTTPServerException
      raise "Error trying to load realresolution ftp information from data bag."
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
    :realres => realres,
    :realsvc => realsvc
  )
  notifies :restart, resources(:service => "altitomcat")
end

%w{/opt/tomcat/CMA /opt/tomcat/CMA/input /opt/tomcat/CMA/input/In /opt/tomcat/CMA/input/Inftp /opt/tomcat/CMA/input/Out /opt/tomcat/CMA/input/Process /opt/tomcat/CMA/input/Process/archive /opt/tomcat/CMA/input/Process/error}.each do |localdir|
  directory "#{localdir}" do
    owner "tomcat"
    group "tomcat"
  end
end



