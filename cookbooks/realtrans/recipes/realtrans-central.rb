#
# Cookbook Name:: realtrans
# Recipe:: realtrans-central
#

#include_recipe "java"
app_name = "realtrans-central"
app_version = node[:realtranscentral_version]
version_str = "realtranscentral_version"

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty? || app_version == "0.0.0-1"
    new_version = search(:node, "#{version_str}:* AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.info("No version for #{app_name} software package found.")
    else
      version_string = []
      new_version.each do |version|
        version_string << version["#{version_str}"]
      end
      new_version = version_string.sort.uniq.last
      app_version = new_version
      node.set["#{version_str}"] = app_version
    end
    if app_version == "0.0.0-1"
      Chef::Log.info("Version is still the default version.")
    end
    if app_version == "0.0.0-1"
      Chef::Log.info("Version is still the default version, the application will not be installed.")
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

include_recipe "realtrans::default"
rdochost = node[:rdochost]
rdocport = node[:rdocport]

rtcenhost = node[:rtcenhost]
rtcenport = node[:rtcenport]

amqphost = node[:amqphost]
amqpport = node[:amqpport]

# Defines the tomcat server to allow for restart/enabling the service
service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

# Install the application package. This app requires an application version since it allows for downgrading.  If the package_noinstall attribute is set, skip installing the rpm (This is for dev environments where manual installation is desired).
yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed for version is still invalid default.")
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
rtrabbit = rtrabbit['user'].split(" ").first.split("|")
# Obtain melissadata URL's to be passed to the property files from the data bag.
melissadata = data_bag_item("integration", "melissadata")
# Obtain mail server information to be passed to property file from the data bag.
mailserver = data_bag_item("integration", "mail")
# Obtain ldap server information to be passed to property file from the data bag.
ldapserver = data_bag_item("integration", "ldap")
# Internal/External names (if configured)
internalName = webHost["rt#{node.chef_environment}"]
externalName = webHost["rte#{node.chef_environment}"]
if externalName.nil? || externalName.empty?
	externalName = internalName
end

# Template resource that creates the property file.
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :webHostname => internalName,
    :extHostname => externalName,
    :rt_cen_host => "#{rtcenhost}:#{rtcenport}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{rtrabbit[0]}",
    :amqppass => "#{rtrabbit[1]}",
    :realdoc_hostname => "#{rdochost}:#{rdocport}",
    :mailserver => mailserver,
    :melissadata => melissadata['melissadata'],
    :ldapserver => ldapserver,
    :maxfilesize => node[:realtrans][:logging][:maxfilesize],
    :maxfilehistory => node[:realtrans][:logging][:maxhistory]
  )
  notifies :restart, resources(:service => "altitomcat")
end

# Obtain mysqldb information for context file.
begin
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
    rescue Net::HTTPServerException
      mysqldb = data_bag_item("infrastructure", "mysqldb")
        rescue Net::HTTPServerException
          raise "Unable to find default or environment mysqldb databag."
end
# Template that creates the application context for database connection pooling.
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb['realtrans'])
  notifies :restart, resources(:service => "altitomcat")
end

