#
# Cookbook Name:: realtrans
# Recipe:: realtrans-reg
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realtrans-reg"
app_version = node[:realtransreg_version]
version_str = "realtransreg_version"

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
        version_string << version[version_str]
      end
      new_version = version_string.sort.uniq.last
      app_version = new_version
      node.set[version_str] = app_version
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

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package app_name do
  version app_version
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set  to not be installed for version is still invalid default.")
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

# Integration Components
webHost = data_bag_item("infrastructure", "apache")
rtrabbit = data_bag_item("rabbitmq", "realtrans")['user'].split(" ").first.split("|")
melissadata = data_bag_item("integration", "melissadata")['melissadata']
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
# Internal/External names (if configured)
internalName = webHost["rt#{node.chef_environment}"]
externalName = webHost["rte#{node.chef_environment}"]
if externalName.nil? || externalName.empty?
	externalName = internalName
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
    :webHostname => internalName,
    :extHostname => externalName,
    :realdoc_hostname => "#{rdochost}:#{rdocport}",
    :rtng_rdoc_user => node[:rtng_realdoc_username],
    :rt_cen_host => "#{rtcenhost}:#{rtcenport}",
    :amqphost => amqphost,
    :amqpport => amqpport,
    :amqpuser => rtrabbit[0],
    :amqppass => rtrabbit[1],
    :amqpvhost =>  node[:realtrans_amqp_vhost],
    :melissa_data_address_url => melissadata['addressurl'],
    :melissa_data_phone_url => melissadata['phoneurl'],
    :melissa_data_email_url => melissadata['emailurl'],
    :melissa_data_geocode_url => melissadata['geocodeurl'],
    :melissa_data_name_url => melissadata['nameurl'],
    :melissa_data_express_url => melissadata['express_webhost'] || 
                                 node[:realtrans][:melissadata][:expressentry][:webhost],
    :melissa_data_express_all_words => melissadata['express_all_words'] || 
                                       node[:realtrans][:melissadata][:expressentry][:all_words],
    :melissa_data_express_max_matches => melissadata['express_max_matches'] || 
                                         node[:realtrans][:melissadata][:expressentry][:max_matches],
    :mail_server_host => mailserver['host'].split(':')[0],
    :mail_server_port => mailserver['host'].split(':')[1],
    :mail_server_user => mailserver['user'],
    :mail_server_pass => mailserver['pass'],
    :mail_server_from => mailserver['from'],
    :ldap_url => ldapserver['ldaphost'],
    :ldap_host => ldapserver['ldaphost'].split(":")[0],
    :ldap_port => ldapserver['ldaphost'].split(":")[1],
    :ldap_search_base => ldapserver['searchbase'],
    :ldap_disabled => node.attribute?('ldap_disable') || 
                      ldapserver['ldaphost'].split(":")[0] == "dummy",
    :tenant_id => node[:tenantid],
    :rf_dao_flag => node[:rf_dao_flag],
    :has_role_implementer => node.run_list?('role[implementer]'),
    :rf_app_config_flag => node.attribute?('rf_app_config_flag'),
    :rt_show_stacktrace => node.attribute?('realtrans_stacktrace'),
    :maxfilesize => node[:realtrans][:logging][:maxfilesize],
    :maxhistory => node[:realtrans][:logging][:maxhistory] 

  )
end

begin
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")['realtrans']
    rescue Net::HTTPServerException
      mysqldb = data_bag_item("infrastructure", "mysqldb")
        rescue Net::HTTPServerException
          raise "Unable to find default or environment mysqldb databag."
end
template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(
    :mysqldb_server => node[:db_server],
    :mysqldb_port => node[:db_port],
    :mysqldb_name => mysqldb['rt_dbname'],
    :mysqldb_user => mysqldb['rt_dbuser'],
    :mysqldb_pass => mysqldb['rt_dbpass'],
    :db_max_active => node[:db_maxactive],
    :db_max_idle => node[:db_maxidle],
    :db_max_wait => node[:db_maxwait],
    :db_time_evict => node[:db_timeevict],
    :db_validation_query_timeout => node[:db_valquerytimeout],
    :db_init_size => node[:db_initsize]
  )
  notifies :restart, resources(:service => "altitomcat")
end
