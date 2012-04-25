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
  version "#{app_version}"
  action :install
  notifies :restart, resources(:service => "altitomcat")
  only_if "test ! -f /etc/init.d/altitomcat"
end

package "#{app_name}" do
  version "#{app_version}"
  action :upgrade
  notifies :restart, resources(:service => "altitomcat")
  only_if "test -f /etc/init.d/altitomcat"
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
end

