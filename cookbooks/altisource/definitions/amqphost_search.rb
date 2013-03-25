#
# Cookbook Name:: altisource
# Definition:: amqphost_search
#

define :amqphost_search do
  
  if node.attribute?("performance")
    environment = "#{node.chef_environment}"
  else
    environment = "shared"
  end
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  # This looks for rabbitmq proxy attribute "ip/hostname:port" or finds the first instance itself.
  if node.attribute?('amqpproxy')
    amqphost = node[:amqpproxy].split(":")[0]
    amqpport = node[:amqpproxy].split(":")[1]
  else
    amqphost = []
    appdata["rabbitmq"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environment}").each do |worker|
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
  Chef::Log.info("Rabbithost set to #{amqphost}")
  node.default.amqphost = amqphost
  node.default.amqpport = amqpport

end

