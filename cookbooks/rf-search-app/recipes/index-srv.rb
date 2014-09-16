#
# Cookbook Name:: rf-search-app
# Recipe:: index-srv 
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"
include_recipe "java"
include_recipe "iptables::disabled"
include_recipe "tomcat-all"
include_recipe "rf-search-app::app_search"

template "/opt/tomcat/conf/rf-realsearch.properties" do
  source "rf-realsearch.properties.erb"
  mode 0775
  owner "tomcat"
  group "tomcat"
end

jvm_params = []

if node['rf-search-app']['tomcat']['setenv_catalina_opts']
  jvm_params << "#{node['rf-search-app']['tomcat']['setenv_catalina_opts']}"
end

template "/opt/tomcat/bin/setenv.sh" do
  source "setenv.sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
  variables(
      :parameters => jvm_params
  )
end


if !node['realsearch-indexservice']['rpm']['version'].nil? && !node['realsearch-indexservice']['rpm']['version'].empty?
  Chef::Log.info("Installing indexservice with version #{node['realsearch-indexservice']['rpm']['version']}")
  yum_package "realsearch-indexservice" do
    action :install
    version "#{node['realsearch-indexservice']['rpm']['version']}"
    allow_downgrade true
  end
else
  yum_package "realsearch-indexservice" do
    action :upgrade
  end
end


execute "clean tomcat privs" do
  command 'chown -R tomcat:tomcat /opt/tomcat; chmod -R 775 /opt/tomcat'
end

service "tomcat" do
  action :restart
end
