#
# Cookbook Name:: realdoc
# Recipe:: jdbc-data-provider
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "jdbc-data-provider"
app_version = node[:jdbcprov_version]
version_str = "jdbcprov_version"

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty? || app_version == "0.0.0-1"
    new_version = search(:node, "#{version_str}:* AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
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

include_recipe "altisource::altitomcat"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed.")
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

mongoHost = "127.0.0.1"
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( :mongo_host => "#{mongoHost}" )
  notifies :restart, resources(:service => "altitomcat")
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
  variables(:mysqldb => mysqldb["jdbcpr"])
  notifies :restart, resources(:service => "altitomcat")
end

