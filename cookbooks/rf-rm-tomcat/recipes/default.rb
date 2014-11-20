#
# Cookbook Name:: rf-rm-tomcat
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"
include_recipe "java"
include_recipe "tomcat-all"
include_recipe "iptables::disabled"

directory "/opt/tomcat/webapps/rsng-rules-integration-rest" do
  recursive true
  action :delete
end

directory "/opt/tomcat/webapps/rsng-rules-mgmt-rest" do
  recursive true
  action :delete
end

directory "/opt/tomcat/webapps/rules-mgmt" do
  recursive true
  action :delete
end

Chef::Log.info("Installing rf-rm-tomcat rpms with version #{node['rf_rm_rpm_version']}")
yum_package "rules-mgmt-intrestwar" do
   action :install
   version "#{node['rf_rm_rpm_version']}"
   allow_downgrade true   
end

yum_package "rules-mgmt-restwar" do
   action :install
   version "#{node['rf_rm_rpm_version']}"
   allow_downgrade true   
end

yum_package "rules-mgmt-uiwar" do
   action :install
   version "#{node['rf_rm_rpm_version']}"
   allow_downgrade true   
end

execute "clean tomcat privs" do 
   command 'chown -R tomcat:tomcat /opt/tomcat; chmod -R 775 /opt/tomcat'
end

file "/etc/init.d/altitomcat" do
    action :delete
end

template "/opt/tomcat/bin/setenv.sh" do
     source "setenv.sh.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
end

template "/opt/tomcat/conf/server.xml" do
    source "server.xml.erb"
end

template "/opt/tomcat/conf/rf-rules-mgmt.properties" do
    source "rf-rules-mgmt.properties.erb"
end

service "tomcat" do 
  action :restart
end

