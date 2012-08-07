#
# Cookbook Name:: realdoc
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "realdoc"
app_version = node[:realdoc_version]

include_recipe "altitomcat"

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

yum_package "#{app_name}" do
  version "#{app_version}"
  case node.chef_environment
  when "Dev","Intdev"
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

package "msttcorefonts" do
  action :upgrade
end

template "/opt/tomcat/conf/realdoc.properties" do
  source "realdoc.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/realdoc.xml" do
  source "realdoc.xml.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
end

directory "/opt/tomcat/correspondence" do
  owner "tomcat"
  group "tomcat"
end

directory "/opt/tomcat/correspondence/input" do
  owner "tomcat"
  group "tomcat"
end

template "/opt/tomcat/conf/realdoc.key" do
  source "realdoc.key.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0600"
end

