#
# Cookbook Name:: appdynamics
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

directory "/opt/appdynamic-agent" do
  owner "root"
  group "root"
end

execute "appdynamicdownload" do
  user "root"
  cwd  "/tmp"
  command "wget -O /tmp/AppServerAgent.zip http://10.0.0.20/yum/common/AppServerAgent.zip; cd /opt/appdynamic-agent; unzip /tmp/AppServerAgent.zip; rm -f /tmp/AppServerAgent.zip"
  creates "/opt/appdynamic-agent/javaagent.jar"
  action :run
end

