#
# Cookbook Name:: realdoc
# Recipe:: rd-transcentra-recon-adapter
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

vendor_name = "walz"
app_name = "rd-#{vendor_name}-print-recon-adapter"
app_version = node["#{vendor_name}_recon_version"]
version_str = "#{vendor_name}_recon_version"

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

# trigger node attribute creation.
include_recipe "realdoc::default"
amqphost = node[:amqphost]
amqpport = node[:amqpport]

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

# this rpm replaces the old transcentra adapter so we need to be sure to uninstall it
yum_package '' do
  action :remove
end
yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed.")
    action :nothing
  else
    action :install
  end
  flush_cache [:before]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

config = node[:print_recon_adapters][vendor_name]
# Integration components
# Try to pull environment specific data bag item for ftp config if it exists.
begin
  ftp_credentials = data_bag_item("integration", "#{vendor_name}_recon_#{node.chef_environment}")
rescue Net::HTTPServerException
  raise "Error trying to load ftp config information from infrastructure data bag."
end

begin
  amqp = data_bag_item("rabbitmq", "realdoc")
  amqp = amqp['user'].split(" ").first.split("|")
rescue Net::HTTPServerException
  raise "Error trying to load the databag for rabbitmq from infrastructure data bag."
end

begin
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
rescue Net::HTTPServerException
  mysqldb = data_bag_item("infrastructure", "mysqldb")
rescue Net::HTTPServerException
  raise "Error trying to load mysqldb information from infrastructure data bag."
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source 'print-recon-adapter.properties.erb'
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
      :vendor_code => vendor_name,
      :mongo => {
          :host => '127.0.0.1',
          :database => node[:mongodb_database]
      },
      :amqp => {
          :host => "#{amqphost}",
          :port => "#{amqpport}",
          :username => "#{amqp[0]}",
          :password => "#{amqp[1]}",
          :vhost => node[:realdoc_amqp_vhost]
      },
      :dirs => config[:dirs],
      :ftp => {
          :host => config[:host],
          :username => ftp_credentials['username'],
          :password => ftp_credentials['password']
      }
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source 'print-recon-adapter.xml.erb'
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb["realdoc"])
  notifies :restart, resources(:service => "altitomcat")
end

