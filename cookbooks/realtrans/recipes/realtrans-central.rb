#
# Cookbook Name:: realtrans
# Recipe:: realtrans-central
#

#include_recipe "java"
app_name = "realtrans-central"
app_version = node[:realtranscentral_version]

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:realtrans\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version[:realtranscentral_version]
      node.set['realtranscentral_version'] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

# Include tomcat recipe to get tomcat installed
include_recipe "altisource::altitomcat"

include_recipe "realtrans::default"
# This looks for realdoc proxy attribute and allows override of realdoc server or finds the first server itself
#if node.attribute?('realdocproxy')
#  rdochost = node[:realdocproxy].split(":")[0]
#  rdocport = node[:realdocproxy].split(":")[1]
#else
#  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
#    if rdochost.nil? || rdochost.empty?
#    Chef::Log.warn("No services returned from search.") && rdochost = "No servers found."
#  else
#    rdochost = rdochost.first
#    rdochost = rdochost["ipaddress"]
#    rdocport = "8080"
#  end
#end

# This looks for rt central proxy attribute or finds the first server itself.
if node.attribute?('rtcenproxy')
  rtcenhost = node[:rtcenproxy].split(":")[0]
  rtcenport = node[:rtcenproxy].split(":")[1]
else
  rtcenhost = search(:node, "recipes:realtrans\\:\\:realtrans-central OR role:realtrans-cen AND chef_environment:#{node.chef_environment}")
  if rtcenhost.nil? || rtcenhost.empty?
    Chef::Log.warn("No services returned from search.") && rtcenhost = "No servers found."
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
    Chef::Log.warn("No services returned from search.") && rtvenhost = "No servers found."
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
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No services returned from search.") && amqphost = "No servers found."
  else
    amqphost = amqphost.first
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

