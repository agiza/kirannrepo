#
# Cookbook Name:: altisource
# Recipe:: altitomcat
#

#include_recipe "java"
include_recipe "altisource::yumclient"
include_recipe "altisource::altirepo"

# make the directory for tomcat mount.
directory "/opt/tomcat" do
end

#volumes = "sdb|opt|opt/tomcat"
node.default.volumes = "sdb|opt|opt/tomcat"
include_recipe "altisource::volgrp"

app_name = "altitomcat"


package "altitomcat" do
  action :upgrade
end

package "jre" do
  action :upgrade
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

# configure appdynamics agent after altitomcat rpm installation but before configuration.
if node.attribute?('performance')
  appdynhost = search(:node, "recipes:altisource\\:\\:appdynamicsserver OR role:appdynamics-server AND chef_environment:#{node.chef_environment}")
  if appdynhost.nil? || appdynhost.empty?
    Chef::Log.info("No services returned from search.")
  else
    appdynhost = appdynhost.first
    appdynhost = appdynhost["ipaddress"]
  end
else
  appdynhost = search(:node, "recipes:altisource\\:\\:appdynamicsserver OR role:appdynamics-server AND chef_environment:shared")
  if appdynhost.nil? || appdynhost.empty?
    Chef::Log.info("No services returned from search.")
  else
    appdynhost = appdynhost.first
    appdynhost = appdynhost["ipaddress"]
  end
end
if appdynhost.nil? || appdynhost.empty?
  Chef::Log.info("No services returned from search.")
else
  include_recipe "altisource::appdynamics"
  appdynstring = "-Dappdynamics.controller.hostName=#{appdynhost} -Dappdynamics.controller.port=8090"
  appdynagent = "-javaagent:/opt/appdynamic-agent/javaagent.jar "
end

template "/opt/tomcat/bin/setenv.sh" do
  source "setenv.sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
  variables(:appdynstring => "#{appdynstring}",
            :appdynagent => "#{appdynagent}"
           )
  notifies :restart, resources(:service => "altitomcat"), :delayed
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
  #notifies :restart, resources(:service => "altitomcat"), :delayed
end

template "/opt/tomcat/conf/server.xml" do
  source "server.xml.erb"
  group  "tomcat"
  owner  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat"), :delayed
end

template "/etc/logrotate.d/altitomcat" do
  source "altitomcat-log.erb"
  group  "root"
  owner  "root"
  mode   "0644"
end

service "altitomcat" do
  action [:enable, :start]
end

