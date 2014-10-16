#
# Cookbook Name:: rf-elasticsearch
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
#
# Cookbook Name:: rf-elasticsearch
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe "java-wrapper"
include_recipe "iptables::disabled"
include_recipe "elasticsearch"
include_recipe "elasticsearch::plugins"
include_recipe "elasticsearch::search_discovery"
include_recipe "altisource::altirepo"

#config:templates
directory "#{node['elasticsearch']['path']['init']['templates']}" do
  mode 00755
  owner "elasticsearch" #elasticsearch
  group "elasticsearch"
  action :create
  recursive true
end
#config:templates:audit0
template "#{node['elasticsearch']['path']['init']['templates']}/audit_template.json" do
  source "audit_template.json.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#config:templates:audit1
template "#{node['elasticsearch']['path']['init']['templates']}/audit_user_management_template.json" do
  source "audit_user_management_template.json.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#config:templates:search
template "#{node['elasticsearch']['path']['init']['templates']}/search_template.json" do
  source "search_template.json.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#config:scripts
directory "#{node['elasticsearch']['path']['init']['scripts']}" do
  mode 00755
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

#config:scripts:inner-delete
template "#{node['elasticsearch']['path']['init']['scripts']}/inner_delete.mvel" do
  source "inner_delete.mvel.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#config:scripts:inner-update
template "#{node['elasticsearch']['path']['init']['scripts']}/inner_update.mvel" do
  source "inner_update.mvel.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#config:scripts:nested-delete
template "#{node['elasticsearch']['path']['init']['scripts']}/nested_delete.mvel" do
  source "nested_delete.mvel.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#config:scripts:nested-update
template "#{node['elasticsearch']['path']['init']['scripts']}/nested_update.mvel" do
  source "nested_update.mvel.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#indices:mappings:audit
directory "#{node['elasticsearch']['path']['indices']['mappings']['audit']}" do
  mode 00755
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

template "#{node['elasticsearch']['path']['indices']['mappings']['audit']}/index_user_management_iam_auditing.sh" do
  source "index_user_management_iam_auditing.sh.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

#indices:mappings:workflow
directory "#{node['elasticsearch']['path']['indices']['mappings']['workflow']}" do
  mode 00755
  owner "elasticsearch"
  group "elasticsearch"
  action :create
  recursive true
end

template "#{node['elasticsearch']['path']['indices']['mappings']['workflow']}/taskData.sh" do
  source "taskData.sh.erb"
  mode 00775
  owner "elasticsearch"
  group "elasticsearch"
end

execute "head plugin install" do
  command "#{node['elasticsearch']['dir']}/elasticsearch/bin/plugin -install mobz/elasticsearch-head"
  not_if do
    File.exists?("#{node['elasticsearch']['dir']}/elasticsearch/plugins/head")
  end
  notifies :restart, "service[elasticsearch]", :immediately
end

if !node['elasticsearch'].to_s.empty? && !node['elasticsearch']['schedulerplugin'].to_s.empty? && !node['elasticsearch']['schedulerplugin']['rpm'].to_s.empty? && !node['elasticsearch']['schedulerplugin']['rpm']['version'].to_s.empty?
  Chef::Log.info("Installing scheduler plugin with version #{node['elasticsearch']['schedulerplugin']['rpm']['version']}")
  yum_package "elasticsearch-scheduler-plugin" do
    action :install
    version "#{node['elasticsearch']['schedulerplugin']['rpm']['version']}"
    allow_downgrade true
  end
else
  yum_package "elasticsearch-scheduler-plugin" do
    action :upgrade
  end
end


service "elasticsearch" do
  action :start
end

#Run a script to join the cluster.
results = "/tmp/output_index_user_management_iam_auditing.txt"
file results do
  action :delete
end

execute "Index script" do
  command "#{node['elasticsearch']['path']['indices']['mappings']['audit']}/index_user_management_iam_auditing.sh &>> #{results}"
  only_if do
    audit_dir = "nodes/0/indices/audit_user_management*"
    files = File.join("#{node['elasticsearch']['path']['data']}", "#{node['elasticsearch']['cluster']['name']}", audit_dir)
    Chef::Log.info("Files to find: #{files}")
    foundFiles = Dir.glob(files)
    Chef::Log.info("Files found: #{foundFiles}")
    foundFiles.empty?
  end
end

#Print results from the bash commands from above
ruby_block "Results" do
  only_if { ::File.exists?(results) }
  block do
    print "\n"
    File.open(results).each do |line|
      print line
    end
  end
end

#Run a script to join the cluster.
results1 = "/tmp/output_task_data.txt"
file results1 do
  action :delete
end

execute "TaskData script" do
  command "#{node['elasticsearch']['path']['indices']['mappings']['workflow']}/taskData.sh &>> #{results1}"
  not_if do
    wflow_dir = "nodes/0/indices/ru_workflow"
    File.exists?(File.join("#{node['elasticsearch']['path']['data']}", "#{node['elasticsearch']['cluster']['name']}", wflow_dir))
  end
end

#Print results from the bash commands from above
ruby_block "Results1" do
  only_if { ::File.exists?(results1) }
  block do
    print "\n"
    File.open(results).each do |line|
      print line
    end
  end
end