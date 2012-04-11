#
# Cookbook Name:: altitomcat
# Recipe:: default
#

#include_recipe "java"
app_name = "altitomcat"
app_version = node[:altitomcat_version]

package "#{app_name}" do
  version "#{app_version}"
  action :reinstall
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
end

template "/etc/sysconfig/real_settings" do
  source "real_settings.erb"
  group 'root'
  owner 'root'
  mode '0644'
  #notifies :restart, resources(:service => "tomcat")
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
end

