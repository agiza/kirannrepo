#
# Cookbook Name:: realdoc
# Recipe:: strongmail-adapter
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "strongmail-adapter"
app_version = node[:smadapter_version]
version_str = "smadapter_version"

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
  else
    Chef::Log.info("Found version attribute.")
  end
end

# trigger node attribute creation.
include_recipe "realdoc::default"

mongo_host = "127.0.0.1"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed.")
    action :nothing
  else
    action :install
  end
  flush_cache [:before]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

begin
  amqp = data_bag_item("rabbitmq", "realdoc")
  amqp_credentials = amqp['user'].split(" ").first.split("|")
rescue Net::HTTPServerException
  raise "Error loading rabbitmq credentials from rabbitmq data bag."
end

begin
  mailserver = data_bag_item("integration", "mail")
rescue Net::HTTPServerException
  raise "Error loading mail info from integration data bag."
end


begin
  strongmail = data_bag_item("infrastructure", "strongmail_#{node.chef_environment}")
rescue Net::HTTPServerException
  raise "Error trying to load mysqldb information from infrastructure data bag."
end

db = node[:strongmail_db]
db_username = strongmail['username']
db_password = strongmail['password']
app_id="realdoc-#{node.chef_environment}"

if db[:type] == 'oracle'
  success_query="select distinct * from sm_success_log where datestamp >= to_timestamp('[datestring]', 'mm-dd-yyyy hh24:mi:ss.ff') and userid = '#{app_id}' order by datestamp, messageid"
  aggregate_query="select distinct * from sm_aggregate_log where datestamp >= to_timestamp('[datestring]', 'mm-dd-yyyy hh24:mi:ss.ff') and userid = '#{app_id}' order by datestamp, messageid"
else
  success_query="select distinct * from sm_success_log where datestamp >= str_to_date('datestring', '%m-%d-%y %h:%i:%s') and userid='#{app_id}' order by datestamp, messageid"
  aggregate_query="select logtype, logname , logdate datestamp, sno, mailingid, dbid, messageid, userid, dbrownum, dbname, msgsno, email, bounce, category, bouncetype, code, vsgname, outboundip, mxip from sm_aggregate_log where logdate >= str_to_date('datestring', '%m-%d-%y %h:%i:%s') and userid='#{app_id}' order by logdate, messageid"
end


template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(
      :amqp => {
          :host => node[:amqphost],
          :port => node[:amqpport],
          :vhost => node[:realdoc_amqp_vhost],
          :username => amqp_credentials[0],
          :password => amqp_credentials[1]
      },
      :mailserver => mailserver,
      :mongo => {
          :host => "#{mongo_host}",
          :dbname => node[:mongodb_database]
      },
      :success_query => success_query,
      :aggregate_query => aggregate_query
  )
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(
      :db => db,
      :db_username => db_username,
      :db_password => db_password
  )
  notifies :restart, resources(:service => "altitomcat")
end

