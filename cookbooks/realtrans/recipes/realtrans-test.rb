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

network_test "#{amqphost}" do
  port "#{amqpport}"
end

network_test "#{rdochost}" do
  port "#{rdocport}"
end

#CA section
begin
  caurl = data_bag_item("integration", "CA")
  rescue Net::HTTPServerException
    raise "Unable to load Collateral Analytics URL from integration data bag."
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
  network_test "#{cahost}" do
    port "#{caport}"
  end
end
begin
  mail = data_bag_item("integration", "mail")
  rescue Net::HTTPServerException
    raise "Unable to load mailserver from integration data bag."
end
mailhost = mail["host"].split(":")[0]
mailport = mail["host"].split(":")[1]
network_test "#{mailhost}" do
  port "#{mailport}"
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
  network_test "#{melissahost}" do
    port "#{melissaport}"
  end
end

begin
  realres = data_bag_item("integration", "realresolution")
  rescue Net::HTTPServerException
    raise "Unable to load realresolution ftp host from integration data bag."
end
realreshost = realres["ftphost"].split(":")[0]
realresport = realres["ftphost"].split(":")[1]
if realreshost.nil? || realreshost.empty?
  Chef::Log.error("Unable to determine a host for Realresolution to test.")
else
  network_test "#{realreshost}" do
    port "#{realresport}"
  end
end

begin
  realserv = data_bag_item("integration", "realservicing")
  rescue Net::HTTPServerException
    raise "Unable to load realservicing legacy webservice url from integration data bag."
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
  network_test "#{realservhost}" do
    port "#{realservport}"
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
  network_test "#{ldaphost}" do
    port "#{ldapport}"
  end
end

mysqldbhost = node[:db_server]
mysqldbport = node[:db_port]
if mysqldbhost.nil? || mysqldbhost.empty?
  Chef::Log.error("Unable to identify a host for mysql DB server.")
else
  network_test "#{mysqldbhost}" do
    port "#{mysqldbport}"
  end
end

