#
# Cookbook Name:: infrastructure
# Recipe:: chefclient
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if platform?("centos", "redhat")
  package "chef" do
    action :upgrade
  end
end

