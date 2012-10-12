#
# Cookbook Name:: realtrans
# Recipe:: realtrans-central
#

#include_recipe "java"
app_name = "realtrans-central"
app_version = node[:realtranscentral_version]

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
rtcenhost = {}
search(:node, "role:realtrans-cen AND chef_environment:#{node.chef_environment}") do |n|
  rtcenhost[n.hostname] = {}
end
rtcenhost = rtcenhost.first

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

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( :rt_cen_host => "#{rtcenhost}")
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end
