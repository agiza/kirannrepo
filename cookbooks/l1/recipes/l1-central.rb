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
  if app_version.empty? || app_version.nil?
    new_version = search(:node, "recipes:l1\\:\\:#{app_name} AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.fatal("No version for #{app_name} software package found.")
    else
      new_version = new_version.first
      app_version = new_version["#{app_attr}"]
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

include_recipe "altisource::altitomcat"

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
  if rdochost.nil? || rdochost.empty?
    Chef::Log.warn("No services returned from search.") && rdochost = "No servers found."
  else
    rdochost = rdochost.first
    rdochost = rdochost["ipaddress"]
    rdocport = "8080"
  end
end

if node.attribute?('l1cenproxy')
  l1cenhost = node[:l1cenproxy].split(":")[0]
  l1cenport = node[:l1cenproxy].split(":")[1]
else
  l1cenhost = search(:node, "recipes:l1\\:\\:l1-central OR role:l1-cen AND chef_environment:#{node.chef_environment}")
  if l1cenhost.nil? || l1cenhost.empty?
    Chef::Log.warn("No services returned from search.") && l1cenhost = "No servers found."
  else
    l1cenhost = l1cenhost.first
    l1cenhost = l1cenhost["ipaddress"]
    l1cenport = "8080"
  end
end

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

# Integration components
l1rabbit = data_bag_item("rabbitmq", "l1")
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
mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
# Template that creates the application context for database connection pooling.
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb['l1'])
  notifies :restart, resources(:service => "altitomcat")
end

