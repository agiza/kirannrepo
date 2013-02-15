#
# Cookbook Name:: realtrans
# Recipe:: default
#

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

# This looks for rt central proxy attribute or finds the first server itself.
if node.attribute?('rtcenproxy')
  rtcenhost = node[:rtcenproxy].split(":")[0]
  rtcenport = node[:rtcenproxy].split(":")[1]
else
  rtcenhost = search(:node, "recipes:realtrans\\:\\:realtrans-central OR role:realtrans-cen AND chef_environment:#{node.chef_environment}")
  if rtcenhost.nil? || rtcenhost.empty?
    Chef::Log.warn("No services returned from search.") && rtcenhost = "No servers found."
  else
    rtcenhost = rtcenhost.first
    rtcenhost = rtcenhost["ipaddress"]
    rtcenport = "8080"
  end
end

# This looks for rabbitmq proxy attribute "ip/hostname:port" or finds the first instance itself.
if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = search(:node, "recipes:rabbitmq\\:\\:rabbitmqserver OR role:rabbitserver AND chef_environment:shared")
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No services returned from search.") && amqphost = "No servers found."
  else
    amqphost = amqphost.first
    amqphost = amqphost["ipaddress"]
    amqpport = "5672"
  end
end

# Set default attributes for use by recipes.
node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.rtcenhost = rtcenhost
node.default.rtcenport = rtcenport
node.default.amqphost = amqphost
node.default.amqpport = amqpport

