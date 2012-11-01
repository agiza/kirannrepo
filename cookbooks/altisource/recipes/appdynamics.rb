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

template "/opt/appdynamic-agent/conf/controller-info.xml" do
  source "controller-info.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
end

