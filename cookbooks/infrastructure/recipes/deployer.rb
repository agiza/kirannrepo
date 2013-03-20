#
# Cookbook Name:: infrastructure
# Recipe:: deployer
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

group "rtnextgen" do
  gid 1001
end

user "rtnextgen" do
  comment "rtnextgen User"
  uid 1001
  gid 1001
  home "/home/rtnextgen"
  shell "/bin/bash"
end

%w[/home/rtnextgen /home/rtnextgen/bin /home/rtnextgen/chef-repo /home/rtnextgen/.chef].each do |dir|
  directory dir do
    owner "rtnextgen"
    group "rtnextgen"
    action :create
  end
end

if node.attribute?('yum_server')
  yumserver = node[:yum_server]
else
  yumserver = []
  %w{yumserver yum-repo}.each do |app|
    search(:node, "recipes:*\\:\\:#{app}").each do |worker|
      yumserver << worker["ipaddress"]
    end
  end
  yumserver = yumserver.first
end

template "/home/rtnextgen/bin/chef-cookbook-upload" do
  source "chef-cookbook-upload.erb"
  owner  "rtnextgen"
  group  "rtnextgen"
  mode   "0755"
end

app_names = node[:app_names]
%w{chef-deploy deploy-software chef-provision}.each do |script|
  template "/home/rtnextgen/bin/#{script}" do
    source "#{script}.erb"
    owner  "rtnextgen"
    group  "rtnextgen"
    mode   "0755"
    variables(
      :appnames => app_names,
      :yumserver => yumserver
    )
  end
end

%w[/home/rtnextgen/.chef /home/rtnextgen/.chef/plugins /home/rtnextgen/.chef/plugins/knife].each do |dir|
  directory dir do
    owner "rtnextgen"
    group "rtnextgen"
    action :create
  end
end

%w{set_environment.rb data_bag_export_all.rb node_export_all.rb role_export_all.rb environment_export_all.rb}.each do |plugin|
  template "/home/rtnextgen/.chef/plugins/knife/#{plugin}" do
    source "#{plugin}.erb"
    owner  "rtnextgen"
    group  "rtnextgen"
    mode   "0644"
  end
end
