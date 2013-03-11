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

# Obtain melissadata URL's to be passed to the property files from the data bag.
melissadata = data_bag_item("integration", "melissadata")
# Obtain mail server information to be passed to property file from the data bag.
mailserver = data_bag_item("integration", "mail")
mailhost = mailserver['host'].split(":")[0]
mailport = mailserver['host'].split(":")[1]
altisource_network "#{mailhost}" do
  port "#{mailport}"
  action [:prep, :check]
  provider "altisource_netcheck"
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

altisource_network "#{node[:dbserver]}" do
  port "#{node[:db_port]}"
  action [:prep, :check]
  provider "altisource_netcheck"
end
