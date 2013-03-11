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

#CA section
caurl = data_bag_item("integration", "CA")
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

mail = data_bag_item("integration", "mail")
mailhost = mail["host"].split(":")[0]
mailport = mail["host"].split(":")[1]
altisource_network "#{mailhost}" do
  port "#{mailport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

melissa = data_bag_item("integration", "melissadata")
melissahost = melissa["melissadata"]["addressurl"].split("/")[2]
melissatype =  melissa["melissadata"]["addressurl"].split(":")[0]
if melissatype == "http"
  melissaport = "80"
elsif melissatype == "https"
  melissaport = "443"
else
  Chef::Log.info("Unable to determine melissadata port type.")
end
altisource_network "#{melissahost}" do
  port "#{melissaport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

realres = data_bag_item("integration", "realresolution")
realreshost = realres["ftphost"].split(":")[0]
realresport = realres["ftphost"].split(":")[1]
altisource_network "#{realreshost}" do
  port "#{realresport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

realserv = data_bag_item("integration", "realservicing")
if realserv["requesturl#{chef_environment}"].nil || realserv["requesturl#{chef_environment}"].empty
  realservhost = realserv["requesturl"].split("/")[2]
  realservtype = realserv["requesturl"].split(":")[0]
else
  realservhost = realserv["requesturl#{chef_environment}"].split("/")[2]
  realservtype = realserv["requesturl#{chef_environment}"].split(":")[0]
end
if realservtype == "http"
  realservport = "80"
elsif realservtype == "https"
  realservport = "443"
end
altisource_network "#{realservhost}" do
  port "#{realservport}"
  action [:prep, :check]
  provider "altisource_netcheck"
end

#integration = data_bag_item("integration", "network_check")
#integration["realtrans"].each do |networkcheck|
#  Chef::Log.info("This check is for #{networkcheck[0]}.")
#  checkname = networkcheck[1].split(":")[0]
#  checkport = networkcheck[1].split(":")[1]
#  altisource_network "#{checkname}" do
#    port "#{checkport}"
#    action [:prep, :check]
#    provider "altisource_netcheck"
#  end
#end

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

