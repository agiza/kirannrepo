#
# Cookbook Name:: l1
# Recipe:: default
#

include_recipe "altisource::altitomcat"
begin
  appnames = data_bag_item("infrastructure", "applications")
  rescue Net::HTTPServerException
    raise "No application names found in infrastructure data bag."
end

if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = []
  appnames["appnames"]["realdoc"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
      rdochost << worker
    end
  end
  if rdochost.nil? || rdochost.empty?
    Chef::Log.warn("No realdoc servers returned from search.") && rdochost = "No servers found."
  else
    rdochostip = []
    rdochost.each do |rdochost|
      rdochostip << rdochost["ipaddress"]
    end
    rdochost = rdochostip.sort.first
    rdocport = "8080"
  end
end

if node.attribute?('l1cenproxy')
  l1cenhost = node[:l1cenproxy].split(":")[0]
  l1cenport = node[:l1cenproxy].split(":")[1]
else
  l1cenhost = []
  appnames["appnames"]["l1-central"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|  
      l1cenhost << worker
    end
  end
  if l1cenhost.nil? || l1cenhost.empty?
    Chef::Log.warn("No l1-central servers returned from search.") && l1cenhost = "No servers found."
  else
    l1cenhostip = []
    l1cenhost.each do |l1cenhost|
      l1cenhostip << l1cenhost["ipaddress"]
    end
    l1cenhost = l1cenhostip.sort.first
    l1cenport = "8080"
  end
end

if node.attribute?('amqpproxy')
  amqphost = node[:amqpproxy].split(":")[0]
  amqpport = node[:amqpproxy].split(":")[1]
else
  amqphost = []
  appnames["appnames"]["rabbitmq"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:shared").each do |worker|
      amqphost << worker
    end
  end
  if amqphost.nil? || amqphost.empty?
    Chef::Log.warn("No rabbitmq servers returned from search.") && amqphost = "No servers found."
  else
    amqphostip = []
    amqphost.each do |amqphost|
      amqphostip << amqphost["ipaddress"]
    end
    amqphost = amqphostip.sort.first
    amqpport = "5672"
  end
end

# This looks for amqp vhost attribute or creates one if it is missing.
if node.attribute?('l1_amqp_vhost')
  Chef::Log.info("Rabbitmq vhost attribute found.")
else
  amqpvhost = search(:node, "l1_amqp_vhost:* AND chef_environment:#{node.chef_environment}")
  if amqpvhost.nil? || amqpvhost.empty?
    amqpenviron = "#{node[:chef_environment]}".downcase
    amqpvhost = "l1#{amqpenviron}"
    node.default.l1_amqp_vhost = amqpvhost
  end
end


node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.l1cenhost = l1cenhost
node.default.l1cenport = l1cenport
node.default.amqphost = amqphost
node.default.amqpport = amqpport

