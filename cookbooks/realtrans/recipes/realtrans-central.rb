#
# Cookbook Name:: realtrans
# Recipe:: realtrans-central
#

#include_recipe "java"
app_name = "realtrans-central"
app_version = node[:realtranscentral_version]

# Include tomcat recipe to get tomcat installed
include_recipe "altisource::altitomcat"

# This looks for realdoc proxy attribute and allows override of realdoc server or finds the first server itself
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
# This looks for rt central proxy attribute or finds the first server itself.
if node.attribute?('rtcenproxy')
  rtcenhost = node[:rtcenproxy].split(":")[0]
  rtcenport = node[:rtcenproxy].split(":")[1]
else
  rtcenhost = {}
  search(:node, "role:realtrans-cen AND chef_environment:#{node.chef_environment}") do |n|
    rtcenhost[n.ipaddress] = {}
  end
  rtcenhost = rtcenhost.first
  rtcenport = "8080"
end
# This looks for rt vendor proxy attribute or finds the first server itself.
if node.attribute?('rtvenproxy')
  rtvenhost = node[:rtvenproxy].split(":")[0]
  rtvenport = node[:rtvenproxy].split(":")[1]
else
  rtvenhost = {}
  search(:node, "role:realtrans-ven AND chef_environment:#{node.chef_environment}") do |n|
    rtvenhost[n.ipaddress] = {}
  end
  rtvenhost = rtvenhost.first
  rtvenport = "8080"
end
# This looks for rabbitmq proxy attribute "ip/hostname:port" or finds the first instance itself.
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

# Defines the tomcat server to allow for restart/enabling the service
service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

# Install the application package. This app requires an application version since it allows for downgrading.  If the package_noinstall attribute is set, skip installing the rpm (This is for dev environments where manual installation is desired).
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

# Obtain apache vhost server name for installation into the property files for URL advertisement
webHost = data_bag_item("apache-server", "webhost")
# Obtain rabbitmq user credentials from the rabbitmq data bag.
rtrabbit = data_bag_item("rabbitmq", "realtrans")
rtrabbit = rtrabbit['user'].split("|")
# Obtain melissadata URL's to be passed to the property files from the data bag.
melissadata = data_bag_item("integration", "melissadata")
# Template resource that creates the property file.
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :webHostname => webHost["rt#{node.chef_environment}"],
    :rt_ven_host => "#{rtvenhost}:#{rtvenport}",
    :rt_cen_host => "#{rtcenhost}:#{rtcenport}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rtrabbit[0]}",
    :amqppass => "#{rtrabbit[1]}",
    :realdoc_hostname => "#{rdochost}:#{rdocport}",
    :melissadata => melissadata['melissadata']
  )
  notifies :restart, resources(:service => "altitomcat")
end

# Template that creates the application context for database connection pooling.
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

