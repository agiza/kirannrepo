# Cookbook Name:: altisource
# Recipe:: jacoco-agent
# Installs Jacoco code coverage agent into /opt/jacoco_agent
#
# Copyright 2013, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"

directory node[:altisource][:jacoco_agent][:install_dir] do 
  owner "root"
  group "root"
  mode "0755"
end

remote_file "#{node[:altisource][:jacoco_agent][:install_dir]}/jacoco_agent_package.zip" do
  source "#{node[:altisource][:jacoco_agent][:repo_url]}/org/jacoco/org.jacoco.agent/#{node[:altisource][:jacoco_agent][:version]}/org.jacoco.agent-#{node[:altisource][:jacoco_agent][:version]}.jar"
  mode  "0644"
  owner "root"
  group "root"
  action :create
  notifies :run, "execute[extract_agent_jar]"
end

execute "extract_agent_jar" do
	command "unzip jacoco_agent_package.zip jacocoagent.jar && chmod 644 jacocoagent.jar"
	cwd node[:altisource][:jacoco_agent][:install_dir]
	action :nothing
end
