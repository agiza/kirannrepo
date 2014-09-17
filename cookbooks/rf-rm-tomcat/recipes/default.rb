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

yum_package "rules-mgmt-intrestwar" do
   action :upgrade
end

yum_package "rules-mgmt-restwar" do
   action :upgrade
end

yum_package "rules-mgmt-uiwar" do
   action :upgrade
end

execute "clean tomcat privs" do 
   command 'chown -R tomcat:tomcat /opt/tomcat; chmod -R 775 /opt/tomcat'
end

file "/etc/init.d/altitomcat" do
    action :delete
end
