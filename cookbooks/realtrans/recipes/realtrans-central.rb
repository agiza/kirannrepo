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
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
  rdochost = rdochost.first
    if rdochost.nil? || rdochost.empty?
    Chef::Log.info("No services returned from search.")
  else
    rdochost = rdochost.first
    rdochost = rdochost["ipaddress"]
    rdocport = "8080"
  end
end
# This looks for rt central proxy attribute or finds the first server itself.
if node.attribute?('rtcenproxy')
  rtcenhost = node[:rtcenproxy].split(":")[0]
  rtcenport = node[:rtcenproxy].split(":")[1]
else
  rtcenhost = search(:node, "recipes:realtrans\\:\\:realtrans-central OR role:realtrans-cen AND chef_environment:#{node.chef_environment}")
  if rtcenthost.nil? || rtcenhost.empty?
    Chef::Log.info("No services returned from search.")
  else
    rtcenhost = rtcenhost.first
    rtcenhost = rtcenhost["ipaddress"]
    rtcenport = "8080"
  end
end
# This looks for rt vendor proxy attribute or finds the first server itself.
if node.attribute?('rtvenproxy')
  rtvenhost = node[:rtvenproxy].split(":")[0]
  rtvenport = node[:rtvenproxy].split(":")[1]
else
  rtvenhost = search(:node, "recipes:realtrans\\:\\:realtrans-vp OR role:realtrans-ven AND chef_environment:#{node.chef_environment}")
  if rtvenhost.nil? || rtvenhost.empty?
    Chef::Log.info("No services returned from search.")
  else
    rtvenhost = rtvenhost.first
    rtvenhost = rtvenhost["ipaddress"]
    rtvenport = "8080"
  end
end
# This looks for rabbitmq proxy attribute "ip/hostname:port" or finds the first instance itself.
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver and chef_environment:shared") do
  if amqphost.nil? || amqphost.empty?
    Chef::Log.info("No services returned from search.")
  else
    amqphost = ampqhost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
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

# Integration Elements here
# Obtain apache vhost server name for installation into the property files for URL advertisement
webHost = data_bag_item("infrastructure", "apache")
# Obtain rabbitmq user credentials from the rabbitmq data bag.
rtrabbit = data_bag_item("rabbitmq", "realtrans")
rtrabbit = rtrabbit['user'].split("|")
# Obtain melissadata URL's to be passed to the property files from the data bag.
melissadata = data_bag_item("integration", "melissadata")
# Obtain mail server information to be passed to property file from the data bag.
mailserver = data_bag_item("integration", "mail")
# Obtain ldap server information to be passed to property file from the data bag.
ldapserver = data_bag_item("integration", "ldap")
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
    :mailserver => mailserver,
    :melissadata => melissadata['melissadata'],
    :ldapserver => ldapserver
  )
  notifies :restart, resources(:service => "altitomcat")
end

# Obtain mysqldb information for context file.
mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
# Template that creates the application context for database connection pooling.
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb['realtrans'])
  notifies :restart, resources(:service => "altitomcat")
end

