#
# Cookbook Name:: realtrans-config
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

service "altitomcat" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

template "/opt/tomcat/conf/realtrans-central.properties" do
  source "realtrans-central.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realtrans-rp.properties" do
  source "realtrans-rp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realtrans-fp.properties" do
  source "realtrans-fp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/int-corelogic.properties" do
  source "int-corelogic.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/int-datavision.properties" do
  source "int-datavision.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/int-etrac.properties" do
  source "int-etrac.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/int-interthinx.properties" do
  source "int-interthinx.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/int-rs.properties" do
  source "int-rs.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/int-rres.properties" do
  source "int-rres.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/realtrans-central.xml" do
  source "realtrans-central.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/realtrans-rp.xml" do
  source "realtrans-rp.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/realtrans-fp.xml" do
  source "realtrans-fp.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/rfviewer.properties" do
  source "rfviewer.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/realtrans-vp.properties" do
  source "realtrans-vp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/conf/Catalina/localhost/realtrans-vp.xml" do
  source "realtrans-vp.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat")
end


