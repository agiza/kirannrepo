#
# Cookbook Name:: jasperserver
# Recipe:: jasperserver-pro
#

#iptables_rule "port_apache_tomcat"

app_name = "jasperserver"

#group "jasper" do
#  gid "498"
#end
#
#user "jasper" do
#  comment "jasper User"
#  uid  "498"
#  gid  498
#  home "/opt/installables/apache-tomcat-7.0.53"
#  shell "/bin/bash"
#end

#group "jasper" do
#  gid 498
#  members ["jasper"]
#end

%w[apache-tomcat jre jdk jasperserver-pro jasperreports-server].each do |pkg|
  package pkg do
    action :upgrade
  end
end

#yum_package "nginx-release-centos" do
#  action :upgrade
#end

directory "/opt/installables" do
   owner "jasper"
   group "jasper"
end

directory "/opt/installables/apache-tomcat-7.0.53" do
  owner "jasper"
  group "jasper"
  mode "0755"
   recursive true
end


directory "/opt/installables/jasperreports-server-5.6.0-bin" do
  owner "jasper"
  group "jasper"
  mode "0755"
   recursive true
end


service "jasperserver" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

jvm_params = [
    node[:java_debugger],
    node[:java_mem_min],
    node[:java_mem_max],
    node[:java_perm_size]
  ]

if node.attribute?('performance')
  environment = node.chef_environment
else
  environment = "shared"
end

template "/etc/init.d/jasperserver" do
  source "jasperserver-init.erb"
  group "root"
  owner "root"
  mode "755"
 end

template "/opt/installables/apache-tomcat-7.0.53/bin/setenv.sh" do
  source "setenv.sh.erb"
  group "jasper"
  owner "jasper"
  mode "0755"
  variables(
    :parameters => jvm_params
  )
  notifies :restart, "service[jasperserver]", :delayed
end

template "/opt/installables/apache-tomcat-7.0.53/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "jasper"
  owner "jasper"
  mode "0755"
  notifies :restart, resources(:service => "jasperserver"), :delayed
end

template "/opt/installables/apache-tomcat-7.0.53/conf/server.xml" do
  source "server.xml.erb"
  group  "jasper"
  owner  "jasper"
  mode   "0644"
  notifies :restart, "service[jasperserver]", :delayed
end

directory "/opt/installables/jasperreports-server-5.6.0-bin" do
  owner "jasper"
  group "jasper"
  mode "0755"
end

#service "jasperserver" do
#  supports :stop => true, :start => true, :restart => true, :reload => true
#  action :nothing
#end

template "/opt/installables/jasperreports-server-5.6.0-bin/buildomatic/default_master.properties" do
 source "mysql_master.properties.erb"
  group  "jasper"
  owner  "jasper"
  mode   "0755"
  notifies :restart, resources(:service => "jasperserver")
end

template "/etc/logrotate.d/jasper" do
  source "jasper-log.erb"
  group  "root"
  owner  "root"
  mode   "0644"
end

service "jasperserver" do
  action [:enable, :start]
end

