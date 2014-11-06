#
# Cookbook Name:: infrastructure
# Recipe:: ec2-userkey
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

if platform_family?("rhel")
  authkey "ec2-user" do
    only_if { ::File.directory?("/home/ec2-user") }
  end
end

