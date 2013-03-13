#
# Cookbook Name:: infrastructure
# Recipe:: chefclient
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "altisource::altirepo"

if platform?("centos", "redhat")
  package "chef" do
    action :upgrade
  end
end

if platform?("ubuntu")
  execute "gem-update" do
    command "sudo gem update --no-ri --no-rdoc"
    action :run
  end
end

