#
# Cookbook Name:: altitomcat
# Recipe:: default
#

#include_recipe "java"
app_name = "altitomcat"

package "#{app_name}" do
  version node[:"#{app_name}"_version]
  action :install
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

