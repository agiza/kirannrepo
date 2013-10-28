#
# Cookbook Name:: integration
# Recipe:: int-realservicing-simulator
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "int-realservicing-simulator"
app_version = node[:intrs_sim_version]
version_str = "intrs_sim_version"

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

include_recipe "integration::default"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed for version is still invalid default.")
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/int-realservicing-simulator.properties" do
  source "int-realservicing-simulator.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  variables( 
    :fetch_order_input => node[:int_rs_simulator][:fetch_order_input],
    :rs_save_order_dir => node[:int_rs_simulator][:rs_save_order_dir],
    :rr_save_order_dir => node[:int_rs_simulator][:rr_save_order_dir],
    :poller_delay => node[:int_rs_simulator][:poller_delay]
  )
  notifies :restart, resources(:service => "altitomcat")
end

mysqldb = data_bag_item("infrastructure", "mysqldb#{node.chef_environment}")['realtrans']
template "/opt/tomcat/conf/Catalina/localhost/int-realservicing-simulator.xml" do
  source "int-realservicing-simulator.xml.erb"
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

[node[:int_rs_simulator][:fetch_order_input], 
 node[:int_rs_simulator][:rs_save_order_dir], 
 node[:int_rs_simulator][:rr_save_order_dir]].each do |dir|
  begin
    directory dir do
      owner "tomcat"
      group "tomcat"
      mode '0755'
      recursive true
      action :create
    end
  rescue Errno::ENOENT, Errno::EACCES
    Chef::Log.warn("Could not create directory #{dir}.  Ignoring.")
  end
end
