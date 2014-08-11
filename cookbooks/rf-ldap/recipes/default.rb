#
# Cookbook Name:: rf-ldap
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
include_recipe "java"
include_recipe "tomcat-all"

cookbook_file "/opt/OpenDJ-2.7.0-20140711.zip" do
   source "OpenDJ-2.7.0-20140711.zip"
end

execute "Unzip Opendj" do
   command 'cd /opt; unzip /opt/OpenDJ-2.7.0-20140711.zip'
end

cookbook_file "/tmp/setup.properties" do
   source "setup.properties"
end

cookbook_file "/tmp/generated.ldif" do 
   source "generated.ldif"
end

execute "Opendj setup" do 
  command '/opt/opendj/setup --propertiesFilePath /tmp/setup.properties --acceptLicense --no-prompt'
end


yum_package "apacheds" do 
    action  :upgrade
end

include_recipe "iptables::disabled"

