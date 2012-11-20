#
# Cookbook Name:: altisource
# Recipe:: rhel-local
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::yumclient"

if node.attribute?('rhelrepoproxy') 
  execute "yum" do
    command "yum clean all"
    action :nothing
  end

  template "/etc/yum.repos.d/rhel-local.repo" do
    source "rhel-local.repo.erb"
    mode "0644"
    notifies :run, resources(:execute => "yum")
  end
end

