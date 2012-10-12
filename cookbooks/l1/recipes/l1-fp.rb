#
# Cookbook Name:: l1
# Recipe:: l1-fp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "l1-fp"
app_version = node[:l1fp_version]

include_recipe "altisource::altitomcat"

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy]
else
  rdochost = {}
  search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
    rdochost[n.hostname] = {}
  end
  rdochost = rdochost.first
end
if node.attribute?('l1cenproxy')
  l1cenhost = node[:l1cenproxy]
else
  l1cenhost = {}
  search(:node, "role:l1-cen AND chef_environment:#{node.chef_environment}") do |n|
    l1cenhost[n.hostname] = {}
  end
  l1cenhost = l1cenhost.first
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  case node.chef_environment
  when "Dev","Intdev"
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

webHost = data_bag_item("apache-server", "webhost")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["l1#{node.chef_environment}"],
    :realdoc_hostname => "#{rdochost}",
    :l1_cen_host => "#{l1cenhost}"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

