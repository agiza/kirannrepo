#
# Cookbook Name:: infrastructure
# Recipe:: rootkey
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if platform_family?("rhel")
  authkey "root" do
  end
end

