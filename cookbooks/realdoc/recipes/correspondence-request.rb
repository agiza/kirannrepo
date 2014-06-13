#
# Cookbook Name::  realdoc
# Recipe:: correspondence-request
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name="correspondence-request"
app_version = node[:corrreq_version]
version_str = "corrreq_version"

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
          :host => "#{amqphost}",
          :port => "#{amqpport}",
          :username => "#{rdrabbit[0]}",
          :password => "#{rdrabbit[1]}",
          :vhost => node[:realdoc_amqp_vhost]
      },
        :app_port_corr => node[:microservice][:correspondence_request][:app_port],
        :adm_port_corr => node[:microservice][:correspondence_request][:adm_port],
        :app_port_ods => node[:microservice][:adapter_ods][:app_port],
        :adm_port_ods => node[:microservice][:adapter_ods][:adm_port]
)
end
