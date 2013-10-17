#
# Cookbook Name:: realdoc
# Recipe:: rd-transcentra-recon-adapter
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "rd-transcentra-recon-adapter"
app_version = node[:rdtranscentrarecon_version]
version_str = "rdtranscentrarecon_version"

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
  action :install
end

file "/opt/tomcat/conf/#{app_name}.properties" do
  action :remove
end

file "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  action :delete
end

service "altitomcat" do
  action :restart
end
