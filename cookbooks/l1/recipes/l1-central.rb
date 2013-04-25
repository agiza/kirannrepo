#
# Cookbook Name:: l1
# Recipe:: l1-central
#

app_name = "l1-central"
app_attr = "l1central_version"
app_version = node[:l1central_version]

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty?
    new_version = search(:node, "recipes:*\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.info("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version["#{app_attr}"]
      node.set["#{app_attr}"] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

include_recipe "l1::default"
rdochost = node[:rdochost]
rdocport = node[:rdocport]
l1cenhost = node[:l1cenhost]
l1cenport = node[:l1cenport]
amqphost = node[:amqphost]
amqpport = node[:amqpport]

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed or version is still default.")
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

# Integration components
begin
  l1rabbit = data_bag_item("rabbitmq", "l1")
    rescue Net::HTTPServerException
      raise "Error loading rabbitmq credentials from rabbitmq data bag."
end
l1rabbit = l1rabbit['user'].split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :l1_cen_host => "#{l1cenhost}:#{l1cenport}",
    :amqphost => "#{amqphost}",
    :amqpport => "#{amqpport}",
    :amqpuser => "#{l1rabbit[0]}",
    :amqppass => "#{l1rabbit[1]}",
    :realdoc_hostname => "#{rdochost}:#{rdocport}",
    :melissadata => melissadata['melissadata'],
    :mailserver => mailserver,
    :ldapserver => ldapserver
  )
  notifies :restart, resources(:service => "altitomcat")
end

# Obtain mysqldb information for context file.
begin
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
    rescue Net::HTTPServerException
      mysqldb = data_bag_item("infrastructure", "mysqldb")
        rescue Net::HTTPServerException
          raise "Error loading mysqldb information from infrastructure data bag."
end
# Template that creates the application context for database connection pooling.
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb['l1'])
  notifies :restart, resources(:service => "altitomcat")
end

