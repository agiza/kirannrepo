#
# Cookbook Name:: rf-elasticsearch-t1
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
directory "#{node.normal[:elasticsearch][:path][:init][:templates]}" do 
     mode 00755
     owner "elasticsearch" #elasticsearch
     group "elasticsearch"	 
     action :create
     recursive true	 
end
#config:templates:audit0
template "#{node.normal[:elasticsearch][:path][:init][:templates]}/audit_template.json" do
   source "audit_template.json.erb"
      mode 00775
      owner "elasticsearch"
      group "elasticsearch"
end

#config:templates:audit1
template "#{node.normal[:elasticsearch][:path][:init][:templates]}/audit_user_management_template.json" do
   source "audit_user_management_template.json.erb"
      mode 00775
      owner "elasticsearch"
      group "elasticsearch"
end

#config:templates:search
template "#{node.normal[:elasticsearch][:path][:init][:templates]}/search_template.json" do
   source "search_template.json.erb"
    mode 00775
    owner "elasticsearch"
    group "elasticsearch"
end

#config:scripts
directory "#{node.normal[:elasticsearch][:path][:init][:scripts]}" do 
     mode 00755
     owner "elasticsearch"
     group "elasticsearch"
     action :create
	 recursive true
end

#config:scripts:inner-delete
template "#{node.normal[:elasticsearch][:path][:init][:scripts]}/inner_delete.mvel" do
   source "inner_delete.mvel.erb"
    mode 00775
    owner "elasticsearch"
    group "elasticsearch"
end

#config:scripts:inner-update
template "#{node.normal[:elasticsearch][:path][:init][:scripts]}/inner_update.mvel" do
   source "inner_update.mvel.erb"
    mode 00775
    owner "elasticsearch"
    group "elasticsearch"
end

#config:scripts:nested-delete
template "#{node.normal[:elasticsearch][:path][:init][:scripts]}/nested_delete.mvel" do
   source "nested_delete.mvel.erb"
    mode 00775
    owner "elasticsearch"
    group "elasticsearch"
end

#config:scripts:nested-update
template "#{node.normal[:elasticsearch][:path][:init][:scripts]}/nested_update.mvel" do
   source "nested_update.mvel.erb"
    mode 00775
    owner "elasticsearch"
    group "elasticsearch"
end

#indices:mappings:audit
directory "#{node.normal[:elasticsearch][:path][:indices][:mappings][:audit]}" do 
     mode 00755
     owner "elasticsearch"
     group "elasticsearch"
     action :create
	 recursive true
end

template "#{node.normal[:elasticsearch][:path][:indices][:mappings][:audit]}/index_user_management_iam_auditing.sh" do
   source "index_user_management_iam_auditing.sh.erb"
   mode 00775
   owner "elasticsearch"
   group "elasticsearch"
end

#indices:mappings:workflow
directory "#{node.normal[:elasticsearch][:path][:indices][:mappings][:workflow]}" do 
    mode 00755
    owner "elasticsearch"
    group "elasticsearch"
    action :create
	recursive true	 
end

template "#{node.normal[:elasticsearch][:path][:indices][:mappings][:workflow]}/taskData.sh" do
   source "taskData.sh.erb"
   mode 00775
   owner "elasticsearch"
   group "elasticsearch"
end

package "mysql-connector-java" do
   action :install
end

execute "head plugin install" do 
  command "#{node.normal[:elasticsearch][:dir]}/elasticsearch/bin/plugin -install mobz/elasticsearch-head"
   not_if do
     File.exists?("#{node.normal[:elasticsearch][:dir]}/elasticsearch/plugins/head")
   end
end

yum_package "elasticsearch-scheduler-plugin" do
    action :upgrade
end

service "elasticsearch" do 
   action :start
end

execute "Index script" do 
   command "#{node.normal[:elasticsearch][:path][:indices][:mappings][:audit]}/index_user_management_iam_auditing.sh"
   only_if do
     audit_dir = "nodes/0/indices/audit_user_management*"
     Dir.glob(File.join("#{node.normal[:elasticsearch][:path][:data]}", "#{node.normal[:elasticsearch][:cluster][:name]}", audit_dir)).empty?
   end
end

execute "TaskData script" do
   command "#{node.normal[:elasticsearch][:path][:indices][:mappings][:workflow]}/taskData.sh"
   not_if do
     wflow_dir = "nodes/0/indices/ru_workflow"
     File.exists?(File.join("#{node.normal[:elasticsearch][:path][:data]}", "#{node.normal[:elasticsearch][:cluster][:name]}", wflow_dir))
   end
end