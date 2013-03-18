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
  Chef::Log.warn("No Appdynamics Controllers found.") && appdynhost = "127.0.0.1"
else
  appdynhost = appdynhost.first
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

