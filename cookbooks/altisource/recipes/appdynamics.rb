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

appdynhost = {}
search(:node, "role:appdynamics-server") do |n|
  appdynhost[n.ipaddress] = {}
end
appdynhost = appdynhost.first

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

