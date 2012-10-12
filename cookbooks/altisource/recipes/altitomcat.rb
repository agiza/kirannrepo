#
# Cookbook Name:: altisource
# Recipe:: altitomcat
#

#include_recipe "java"
include_recipe "altisource::appdynamics"
app_name = "altitomcat"

appdynhost = {}
search(:node, "role:appdynamics-server") do |n|
appdynhost[n.hostname] = {}
end
appdynhost = appdynhost.first

unless appdynhost == "nil"
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
  variables(:appdynhost => "#{appdynhost}",
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
