#
# Cookbook Name:: altitomcat
# Recipe:: default
#

#include_recipe "java"
app_name = "altitomcat"

package "#{app_name}" do
  action :upgrade
end

package "appdynamics" do
  action :upgrade
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
  action :start
end

service "splunkforwarder" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :disable
  action :stop
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/splunkforwarder/etc/system/local/outputs.conf" do
  source "outputs.conf.erb"
  group  "splunk"
  owner  "splunk"
  mode   "0644"
  notifies :stop, resources(:service => "splunkforwarder")
end

template "/etc/init.d/splunkforwarder" do
  source "splunkforwarder.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :stop, resources(:service => "splunkforwarder")
end
