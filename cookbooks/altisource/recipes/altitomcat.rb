#
# Cookbook Name:: altisource
# Recipe:: altitomcat
#

#include_recipe "java"
include_recipe "yumclient"

app_name = "altitomcat"

appdynhost = {}
search(:node, "role:appdynamics-server") do |n|
  appdynhost[n.ipaddress] = {}
end
appdynhost = appdynhost.first
if appdynhost.nil? || appdynhost.empty?
  Chef::Log.info("No services returned from search.")
else
  include_recipe "altisource::appdynamics"
  appdynstring = "-Dappdynamics.controller.hostName=#{appdynhost} -Dappdynamics.controller.port=8090"
  appdynagent = "-javaagent:/opt/appdynamic-agent/javaagent.jar "
end

package "#{app_name}" do
  action :upgrade
end

service "altitomcat" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
  variables(:appdynstring => "#{appdynstring}",
            :appdynagent => "#{appdynagent}"
           )
  notifies :restart, resources(:service => "altitomcat"), :delayed
end

template "/opt/tomcat/conf/server.xml" do
  source "server.xml.erb"
  group  "tomcat"
  owner  "tomcat"
  mode   "0644"
  notifies :restart, resources(:service => "altitomcat"), :delayed
end

service "altitomcat" do
  action [:enable, :start]
end
