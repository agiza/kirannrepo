#
# Cookbook Name:: infrastructure
# Recipe:: realsvckey
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if platform_family?("ubuntu")
  authkey "realsvc" do
  end
end

