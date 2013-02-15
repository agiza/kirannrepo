#
# Cookbook Name:: realtrans
# Recipe:: default
#

#include_recipe "java"

# This looks for realdoc proxy attribute and allows override of realdoc server or finds the first server itself
if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
    if rdochost.nil? || rdochost.empty?
    Chef::Log.warn("No services returned from search.") && rdochost = "No servers found."
  else
    rdochost = rdochost.first
    rdochost = rdochost["ipaddress"]
    rdocport = "8080"
  end
end

