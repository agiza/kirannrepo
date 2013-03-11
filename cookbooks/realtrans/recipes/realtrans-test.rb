#
# Cookbook Name:: realtrans
# Recipe:: realtrans-test
#

include_recipe "realtrans::default"
rdochost = node[:rdochost]
rdocport = node[:rdocport]

rtcenhost = node[:rtcenhost]
rtcenport = node[:rtcenport]

amqphost = node[:amqphost]
amqpport = node[:amqpport]

altisource_network "#{amqphost}" do
  port "#{amqpport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

altisource_network "#{rdochost}" do
  port "#{rdocport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

integration = data_bag_item("integration", "network_check")
integration["realtrans"].each do |networkcheck|
  Chef::Log.info("This check is for #{networkcheck[0]}.")
  checkname = networkcheck[1].split(":")[0]
  checkport = networkcheck[1].split(":")[1]
  altisource_network "#{checkname}" do
    port "#{checkport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end

# Obtain ldap server information to be passed to property file from the data bag.
ldapserver = data_bag_item("integration", "ldap")
if ldapserver['ldaphost'].split(":")[0] == "dummy"
  Chef::Log.info("No ldap server so no network test needed.")
else
  ldaphost = ldapserver['ldaphost'].split(":")[0]
  ldapport = ldapserver['ldaphost'].split(":")[1]
  altisource_network "#{ldaphost}" do
    port "#{ldapport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end

mysqldbhost = node[:db_server]
mysqldbport = node[:db_port]
altisource_network "#{mysqldbhost}" do
  port "#{mysqldbport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

