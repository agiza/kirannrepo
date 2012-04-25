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

package "#{app_name}" do
  version "#{app_version}.noarch"
  action :install
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
end

