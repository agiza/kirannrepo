#
# Cookbook Name:: realtrans-rp
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
app_name = "realtrans-rp"
app_version = node[:realtransrp_version]

include_recipe "altitomcat"

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

rdochost = {}
search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
  rdochost[n.hostname] = {}
end
#rdochostname = rdochost[0]
webHost = data_bag_item("apache-server", "webhost")
template "/opt/tomcat/conf/realtrans-rp.properties" do
  source "realtrans-rp.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["rt#{node.chef_environment}"],
    :realdoc_hostname => "#{rdochost}"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/realtrans-rp.xml" do
  source "realtrans-rp.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end
