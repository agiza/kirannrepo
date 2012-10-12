#
# Cookbook Name:: realdoc
# Recipe:: realdoc
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realdoc"
app_version = node[:realdoc_version]

include_recipe "altisource::altitomcat"

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

package "msttcorefonts" do
  action :upgrade
end

if node.attribute?('mongomasterproxy')
  mongoHost = node[:mongomasterproxy]
else
  mongoHost = {}
  search(:node, "role:mongodb-master AND chef_environment:#{node.chef_environment}") do |n|
    mongoHost[n.fqdn] = {}
  end
end
if node.attribute?('elasticsearchproxy')
  elasticHost = node[:elasticsearchproxy]
else
  elasticHost = {}
  search(:node, "role:elasticsearch AND chef_environment:#{node.chef_environment}") do |n|
    elasticHost[n.fqdn] = {}
  end
end
webHost = data_bag_item("apache-server", "webhost")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => webHost["rd#{node.chef_environment}"],
    :mongo_host => "#{mongoHost}",
    :elastic_host => "#{elasticHost}"
  )
end

template "/opt/tomcat/conf/Catalina/localhost/realdoc.xml" do
  source "realdoc.xml.erb"
  group  'tomcat'
  owner  'tomcat'
  mode   '0644'
  notifies :restart, resources(:service => "altitomcat")
end

directory "/opt/tomcat/correspondence" do
  owner "tomcat"
  group "tomcat"
end

directory "/opt/tomcat/correspondence/input" do
  owner "tomcat"
  group "tomcat"
end

template "/opt/tomcat/conf/realdoc.key" do
  source "realdoc.key.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0600"
end

