#
# Cookbook Name:: altisource
# Recipe:: altitomcat
#

#include_recipe "java"
include_recipe "altisource::altirepo"
include_recipe "iptables::default"
iptables_rule "port_tomcat"

#volumes = "sdb|opt|opt/tomcat"
#node.default.volumes = "sdb|opt|opt/tomcat|defaults"
#include_recipe "altisource::volgrp"

include_recipe "altisource::volume"
volume_mount "volume_tomcat" do
  volumes "sdb|opt|opt/tomcat|defaults"
end

app_name = "altitomcat"

%w[altitomcat jre].each do |pkg|
  package pkg do
    action :upgrade
  end
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

# configure appdynamics agent after altitomcat rpm installation but before configuration.
if node.attribute?('performance')
  environment = "#{node.chef_environment}"
else
  environment = "shared"
end
appdynhost = []
%w{appdynamicsserver}.each do |app|
  search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environment}").each do |worker|
    appdynhost << worker["ipaddress"]
  end
end
if appdynhost.nil? || appdynhost.empty?
  Chef::Log.info("No appdynamic controller servers returned from search.")
else
  appdynhost = appdynhost.first
  include_recipe "infrastructure::appdynamics"
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

