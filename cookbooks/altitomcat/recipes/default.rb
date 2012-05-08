#
# Cookbook Name:: altitomcat
# Recipe:: default
#

#include_recipe "java"
app_name = "altitomcat"

package "#{app_name}" do
  action :upgrade
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
  action :start
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
  notifies :restart, resources(:service => "altitomcat")
end

