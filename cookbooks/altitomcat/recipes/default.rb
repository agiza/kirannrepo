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
  version "#{app_version}"
  action :install
  flush_cache [ :before ]
  allow_downgrade true
  notifies :restart, resources(:service => "altitomcat")
end

execute "yum-reinstall" do
  command "yum reinstall -y #{app_name}-#{app_version}"
  creates "/etc/init.d/altitomcat"
  action :run
  only_if "test ! -f /etc/init.d/altitomcat"
  notifies :restart, resources(:service => "altitomcat")
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
end

