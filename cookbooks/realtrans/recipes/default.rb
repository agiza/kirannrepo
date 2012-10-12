#
# Cookbook Name:: realtrans
# Recipe:: default
#

#include_recipe "java"

rdochost = {}
case node.chef_environment
when "Intdev"
  search(:node, "role:realdoc AND chef_environment:Dev") do |n|
  rdochost[n.hostname] = {}
  end
else
  search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
  rdochost[n.hostname] = {}
  end
end
rdochost = rdochost.first
rtcenhost = {}
search(:node, "role:realtrans-cen AND chef_environment:#{node.chef_environment}") do |n|
  rtcenhost[n.hostname] = {}
end
rtcenhost = rtcenhost.first

