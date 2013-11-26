#
# Cookbook Name:: realdoc
# Recipe:: realservicing-correspondence-adapter-tp2
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realservicing-correspondence-adapter-tp2"
app_version = node[:tp2_adapter_version]
version_str = "tp2_adapter_version"

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
include_recipe "infrastructure::ftpserver"
amqphost = node[:amqphost]
amqpport = node[:amqpport]
rdochost = node[:rdochost]
rdocport = node[:rdocport]

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

mongoHost = "127.0.0.1"

# Integration components
webHost = data_bag_item("infrastructure", "apache")
rdrabbit = data_bag_item("rabbitmq", "realdoc")
rdrabbit = rdrabbit['user'].split(" ").first.split("|")
melissadata = data_bag_item("integration", "melissadata")
mailserver = data_bag_item("integration", "mail")
ldapserver = data_bag_item("integration", "ldap")
begin
  mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")
rescue Net::HTTPServerException
  mysqldb = data_bag_item("infrastructure", "mysqldb")
rescue Net::HTTPServerException
  raise "Error trying to load mysqldb information from infrastructure data bag."
end

template "/opt/tomcat/conf/Catalina/localhost/#{app_name}.xml" do
  source "#{app_name}.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables(:mysqldb => mysqldb["realdoc"])
  notifies :restart, resources(:service => "altitomcat")
end

conf = node[:adapters][:rs_inbound]

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables(
      :mongo_host => "#{mongoHost}",
      :amqphost => "#{amqphost}",
      :amqpport => "#{amqpport}",
      :amqpuser => "#{rdrabbit[0]}",
      :amqppass => "#{rdrabbit[1]}",
      :exchange => 'rd.requests',
      :routing_key => 'correspondence.send',
      :xmlBaseDir => conf[:xml_basedir],
      :tp2Dir => conf[:tp2_postsplit_dir],
      :xmlPollFreq => conf[:xml_poll_freq],
      :ioBasedir => conf[:io_basedir],
      :doneFileSuffix => conf[:done_file_suffix]
  )
end

# TODO: move this script to the adapter the rpm. for now this is good enough
template '/opt/realdoc/bin/tp2splitter' do
  source 'tp2splitter.sh.erb'
  group 'tomcat'
  owner 'tomcat'
  mode '0755'
end

# setup splitter cronjob
cron "tp2splitter" do
  command "/opt/realdoc/bin/tp2splitter -s #{conf[:tp2_presplit_dir]} -t #{conf[:tp2_postsplit_dir]} -a #{conf[:io_basedir]}/archive -l #{conf[:tp2_max_lines]}"
end

