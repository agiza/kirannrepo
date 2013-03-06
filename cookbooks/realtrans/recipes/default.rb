#
# Cookbook Name:: realtrans
# Recipe:: default
#

include_recipe "altisource::altitomcat"

# This looks for realdoc proxy attribute and allows override of realdoc server or finds the first server itself
if node.attribute?('realdocproxy')
  rdochost = node[:realdocproxy].split(":")[0]
  rdocport = node[:realdocproxy].split(":")[1]
else
  rdochost = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{node.chef_environment}")
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

# This looks for rt central proxy attribute or finds the first server itself.
if node.attribute?('rtcenproxy')
  rtcenhost = node[:rtcenproxy].split(":")[0]
  rtcenport = node[:rtcenproxy].split(":")[1]
else
  rtcenhost = search(:node, "realtranscentral_version:* AND chef_environment:#{node.chef_environment}")
  if rtcenhost.nil? || rtcenhost.empty?
    Chef::Log.warn("No realtrans-central servers returned from search.") && rtcenhost = "No servers found."
  else
    rtcenhostip = []
    rtcenhost.each do |rtcenhost|
      rtcenhostip << rtcenhost["ipaddress"]
    end
    rtcenhost = rtcenhostip.sort.first
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
if node.attribute?('realtrans_amqp_vhost')
  Chef::Log.info("Rabbitmq vhost attribute found.")
else
  amqpvhost = search(:node, "realtrans_amqp_vhost:* AND chef_environment:#{node.chef_environment}")
  if amqpvhost.nil? || amqpvhost.empty?
    amqpenviron = "#{node[:chef_environment]}".downcase
    amqpvhost = "realtrans#{amqpenviron}"
    node.default.realtrans_amqp_vhost = amqpvhost
  end
end

# Set default attributes for use by recipes.
node.default.rdochost = rdochost
node.default.rdocport = rdocport
node.default.rtcenhost = rtcenhost
node.default.rtcenport = rtcenport
node.default.amqphost = amqphost
node.default.amqpport = amqpport

