#
# Cookbook Name::  realdoc
# Recipe:: adapter-ods-request
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name="adapter-ods"
app_version = node[:ada_ods_version]
version_str = "ada_ods_version"

group "realdoc" do
  gid 1001
end

user "realdoc" do
  comment "Realdoc User"
  uid  "1001"
  gid  1001
  home "/opt/realdoc"
  shell "/bin/bash"
end

group "realdoc" do
  gid 1001
  members ["realdoc"]
end

directory "/opt/realdoc" do
  owner "realdoc"
  group "realdoc"
end

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

service "#{app_name}" do
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
  notifies :restart, resources(:service => "#{app_name}")
end

mongoHost = "127.0.0.1"

amqphost = node[:amqphost]
amqpport = node[:amqpport]
rdochost = node[:rdochost]
rdocport = node[:rdocport]

rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split(" ").first.split("|")

begin
  oradb_ods = data_bag_item("infrastructure", "oradb_ods#{node.chef_environment}")
  rescue Net::HTTPServerException
  oradb_ods = data_bag_item("infrastructure", "oradb_ods")
  raise "Error trying to load oradb information from infrastructure data bag."
end


template "/opt/realdoc/conf/#{app_name}.yaml" do
  source "#{app_name}.yaml.erb"
  group 'realdoc'
  owner 'realdoc'
  mode '0644'
  notifies :restart, resources(:service => "#{app_name}")
  variables(
        :mongo => {
          :host => "node[:mongodb_host]",
          :database => node[:mongodb_database]
		},
       :amqp => {
          :host => "#{amqphost}",
          :port => "#{amqpport}",
          :username => "#{rdrabbit[0]}",
          :password => "#{rdrabbit[1]}",
          :vhost => node[:realdoc_amqp_vhost]
      },
          :oradb_ods => oradb_ods["realdoc"],
          :rdochost => "#{rdochost}"

)
end
