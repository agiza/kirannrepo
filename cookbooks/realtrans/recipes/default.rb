#
# Cookbook Name:: realtrans
# Recipe:: default
#

include_recipe "altisource::altitomcat"

rdochost_search do
end

rtcenhost_search do
end

amqphost_search do
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
#node.default.rdochost = rdochost
#node.default.rdocport = rdocport
#node.default.rtcenhost = rtcenhost
#node.default.rtcenport = rtcenport
#node.default.amqphost = amqphost
#node.default.amqpport = amqpport

