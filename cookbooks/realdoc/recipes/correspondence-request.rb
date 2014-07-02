#
# Cookbook Name::  realdoc
# Recipe:: correspondence-request
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name= "correspondence-request"
app_version = node[:corr_req_version]
version_str = "corr_req_version"

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

rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split(" ").first.split("|")

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


rdochost = node[:rdochost]
rdocport = node[:rdocport]

begin
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
rescue Net::HTTPServerException
  mysqldb = data_bag_item("infrastructure", "mysqldb")
rescue Net::HTTPServerException
  raise "Error trying to load mysqldb information from infrastructure data bag."
end

template "/opt/realdoc/conf/#{app_name}.yaml" do
  source "#{app_name}.yaml.erb"
  group 'realdoc'
  owner 'realdoc'
  mode '0644'
  notifies :restart, resources(:service => "#{app_name}")
  variables(
        :mongo => {
          :host => "#{mongoHost}",
          :database => node[:mongodb_database]
		},
       :amqp => {
          :host => node[:amqphost],
          :port => node[:amqpport],
          :username => "#{rdrabbit[0]}",
          :password => "#{rdrabbit[1]}",
          :vhost => node[:realdoc_amqp_vhost]
      },
        :mysqldb => mysqldb["realdoc"],
        :rdochost => "#{rdochost}"
)
end
