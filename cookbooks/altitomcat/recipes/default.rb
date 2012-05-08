#
# Cookbook Name:: altitomcat
# Recipe:: default
#

#include_recipe "java"
app_name = "altitomcat"
app_version = node[:altitomcat_version]

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

yum_package "#{app_name}" do
  action :upgrade
  flush_cache [ :before ]
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
end

