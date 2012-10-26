#
# Cookbook Name:: ava
# Recipe:: ava-central
#

#include_recipe "java"
app_name = "ava-central"
app_version = node[:avacentral_version]

include_recipe "altisource::altitomcat"

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = {}
  search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
    rdochost[n.ipaddress] = {}
  end
  rdochost = rdochost.first
  rdocport = "8080"
end
if node.attribute?('avacenproxy')
  avacenhost = node[:avacenproxy].split(":")[0]
  avacenport = node[:avacenproxy].split(":")[1]
else
  avacenhost = {}
  search(:node, "role:ava-cen AND chef_environment:#{node.chef_environment}") do |n|
    avacenhost[n.ipaddress] = {}
  end
  avacenhost = avacenhost.first
  avacenport = "8080"
end
if node.attribute?('avavenproxy')
  avavenhost = node[:avavenproxy].split(":")[0]
  avavenport = node[:avavenproxy].split(":")[1]
else
  avavenhost = {}
  search(:node, "role:ava-ven AND chef_environment:#{node.chef_environment}") do |n|
    avavenhost[n.ipaddress] = {}
  end
  avavenhost = avavenhost.first
  avavenport = "8080"
end
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = {}
  search(:node, "role:rabbitserver") do |n|
    amqphost[n.ipaddress] = {}
  end
  amqphost = amqphost.first
  amqpport = "5672"
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall')
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

# Integration Components
webHost = data_bag_item("infrastructure", "apache")
avarabbit = data_bag_item("rabbitmq", "realtrans")
avarabbit = avarabbit['user'].split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :ava_ven_host => "#{avavenhost}:#{avavenport}",
    :ava_cen_host => "#{avacenhost}:#{avacenport}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{avarabbit[0]}",
    :amqppass => "#{avarabbit[1]}",
    :realdoc_hostname => "#{rdochost}:8080",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver,
    :ldapserver => ldapserver
  )
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

