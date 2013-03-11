#
# Cookbook Name:: realtrans
# Recipe:: realtrans-test
#

#include_recipe "realtrans::default"
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

#CA section
begin
  caurl = data_bag_item("integration", "CA")
  raise "Unable to load Collateral Analytics URL from integration data bag item."
end
cahost = caurl["caURL"].split("/")[2]
catype = caurl["caURL"].split(":")[0]
if catype == "http"
  caport = "80"
elsif catype == "https"
  caport = "443"
else
  Chef::Log.error("Unable to determine Collateral Analytics port.")  
end
if cahost == "" || caport == ""
  Chef::Log.error("Unable to determine CA hostname or port.")
else
  altisource_network "#{cahost}" do
    port "#{caport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end
begin
  mail = data_bag_item("integration", "mail")
  raise "Unable to load data bag item for mail within integration data bag."
end
mailhost = mail["host"].split(":")[0]
mailport = mail["host"].split(":")[1]
altisource_network "#{mailhost}" do
  port "#{mailport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end
begin
  melissa = data_bag_item("integration", "melissadata")
  raise "Unable to load data bag item for melissadata address validation in integration data bag."
end
melissahost = melissa["melissadata"]["addressurl"].split("/")[2]
melissatype =  melissa["melissadata"]["addressurl"].split(":")[0]
if melissatype == "http"
  melissaport = "80"
elsif melissatype == "https"
  melissaport = "443"
else
  Chef::Log.error("Unable to determine melissadata port type.")
end
if melissahost.nil? || melissahost.empty?
  Chef::Log.error("Unable to determine hostname for melissadata for network check.")
else
  altisource_network "#{melissahost}" do
    port "#{melissaport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end

begin
  realres = data_bag_item("integration", "realresolution")
  raise "Unable to load data bag item for realresolution ftp server from integration data bag."
end
realreshost = realres["ftphost"].split(":")[0]
realresport = realres["ftphost"].split(":")[1]
if realreshost.nil? || realreshost.empty?
  Chef::Log.error("Unable to determine a host for Realresolution to test.")
else
  altisource_network "#{realreshost}" do
    port "#{realresport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end

begin
  realserv = data_bag_item("integration", "realservicing")
  raise "Unable to load data bag item for realservice legacy webservice from integration data bag."
end
if realserv["requesturl#{node.chef_environment}"].nil? || realserv["requesturl#{node.chef_environment}"].empty?
  realservhost = realserv["requesturl"].split("/")[2]
  realservtype = realserv["requesturl"].split(":")[0]
else
  realservhost = realserv["requesturl#{node.chef_environment}"].split("/")[2]
  realservtype = realserv["requesturl#{node.chef_environment}"].split(":")[0]
end
if realservtype == "http"
  realservport = "80"
elsif realservtype == "https"
  realservport = "443"
end
if realservhost.nil? || realservhost.empty?
  Chef::Log.error("Unable to identify a hostname for realservice legacy webservice for network check.")
else
  altisource_network "#{realservhost}" do
    port "#{realservport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end

# Obtain ldap server information to be passed to property file from the data bag.
begin
  ldapserver = data_bag_item("integration", "ldap")
  raise "Unable to load data bag item for ldap server from integration data bag."
end
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
if mysqldbhost.nil? || mysqldbhost.empty?
  Chef::Log.error("Unable to identify a host for mysql DB server.")
else
  altisource_network "#{mysqldbhost}" do
    port "#{mysqldbport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end

