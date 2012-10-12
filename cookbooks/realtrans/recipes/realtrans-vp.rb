#
# Cookbook Name:: realtrans
# Recipe:: realtrans-vp
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realtrans-vp"
app_version = node[:realtransvp_version]

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
if node.attribute?('rtcenproxy')
  rtcenhost = node[:rtcenproxy]
else
  rtcenhost = {}
  search(:node, "role:realtrans-cen AND chef_environment:#{node.chef_environment}") do |n|
    rtcenhost[n.hostname] = {}
  end
  rtcenhost = rtcenhost.first
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
    :webHostname => webHost["rt#{node.chef_environment}"],
    :realdoc_hostname => "#{rdochost}",
    :rt_cen_host => "#{rtcenhost}"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

