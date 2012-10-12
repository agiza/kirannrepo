#
# Cookbook Name:: ava
# Recipe:: ava-fp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "ava-fp"
app_version = node[:avafp_version]

include_recipe "altisource::altitomcat"
rdochost = {}
case node.chef_environment
when "Intdev"
  search(:node, "role:realdoc AND chef_environment:Dev") do |n|
  rdochost[n.hostname] = {}
  end
else
  search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
  rdochost[n.hostname] = {}
  end
end
rdochost = rdochost.first
avacenhost = {}
search(:node, "role:ava-cen AND chef_environment:#{node.chef_environment}") do |n|
  avacenhost[n.hostname] = {}
end
avacenhost = avacenhost.first


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
    :webHostname => webHost["ava#{node.chef_environment}"],
    :realdoc_hostname => "#{rdochost}",
    :ava_cen_host => "#{avacenhost}"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

