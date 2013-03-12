#
# Cookbook Name:: rsng
# Recipe:: rsng-test
#

include_recipe "rsng::default"

amqphost = node[:amqphost]
amqpport = node[:amqpport]

altisource_network "#{amqphost}" do
  port "#{amqpport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

begin
  mail = data_bag_item("integration", "mail")
  rescue Net::HTTPServerException
    raise "Unable to load mailserver from integration data bag."
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
  rescue Net::HTTPServerException
    raise "Unable to load melissa data URL from integration data bag."
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
  progressdb = data_bag_item("infrastructure", "projourdb#{node.chef_environment}")
  rescue Net::HTTPServerException
    progressdb = data_bag_item("infrastructure", "projourdb")
    raise "Unable to load Progress DB server from infrastructure data bag.")
end
progressdbhost = progressdb["realservice"]["projourdb_server"]
progressdbport = progressdb["realservice"]["projourdb_port"]
if progressdbhost.nil? || progressbhost.empty?
  Chef::Log.error("Unable to identify a hostname for Progress DB server for network check.")
else
  altisource_network "#{progressdbhost}" do
    port "#{progressdbport}"
    action [:prep, :check]
    provider "altisource_netcheck"
  end
end

# Obtain ldap server information to be passed to property file from the data bag.
begin
  ldapserver = data_bag_item("integration", "ldap")
  rescue Net::HTTPServerException
    raise "Unable to load ldap server from integration data bag."
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

