#
# Cookbook Name:: l1
# Recipe:: default
#

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

if node.attribute?('l1cenproxy')
  l1cenhost = node[:l1cenproxy].split(":")[0]
  l1cenport = node[:l1cenproxy].split(":")[1]
else
  l1cenhost = search(:node, "recipes:l1\\:\\:l1-central OR role:l1-cen AND chef_environment:#{node.chef_environment}")
  if l1cenhost.nil? || l1cenhost.empty?
    Chef::Log.warn("No services returned from search.") && l1cenhost = "No servers found."
  else
    l1cenhost = l1cenhost.first
    l1cenhost = l1cenhost["ipaddress"]
    l1cenport = "8080"
  end
end

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

node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.l1cenhost = l1cenhost
node.default.l1cenport = l1cenport
node.default amqphost = amqphost
node.default.amqpport = amqpport

