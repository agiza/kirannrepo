#
# Cookbook Name:: altisource
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
  appdynhost = {}
    search(:node, "role:appdynamics-server AND chef_environment:#{node.chef_environment}") do |n|
      appdynhost[n.ipaddress] = {}
  end
  appdynhost = appdynhost.first
else
  appdynhost = {}
    search(:node, "role:appdynamics-server AND chef_environment:shared") do |n|
    appdynhost[n.ipaddress] = {}
  end
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

