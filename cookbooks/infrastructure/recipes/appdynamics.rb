#
# Cookbook Name:: infrastructure
# Recipe:: appdynamics
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

package "appdynamic-agent" do
  action :upgrade
end

if node.attribute?('performance')
  appdynhost = search(:node, "recipes:infrastructure\\:\\:appdynamicsserver OR role:appdynamics-server AND chef_environment:#{node.chef_environment}")
  if appdynhost.nil? || appdynhost.empty?
    Chef::Log.warn("No Appdynamics Controllers found.") && appdynhost = "127.0.0.1"
  else
    appdynhost = appdynhost.first
    appdynhost = appdynhost["ipaddress"]
  end
else
  appdynhost = search(:node, "recipes:infrastructure\\:\\:appdynamicsserver OR role:appdynamics-server AND chef_environment:shared")
  if appdynhost.nil? || appdynhost.empty?
    Chef::Log.warn("No Appdynamics Controllers found.") && appdynhost = "127.0.0.1"
  else
    appdynhost = appdynhost.first
    appdynhost = appdynhost["ipaddress"]
  end
end

template "/opt/appdynamic-agent/conf/controller-info.xml" do
  source "controller-info.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  variables(
    :appdynhost => appdynhost,
    :appdynport => "8090"
  )
end

