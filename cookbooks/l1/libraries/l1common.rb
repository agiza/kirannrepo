# define a module to mix into Chef::Recipe
class Chef::Recipe::L1Common
  def self.rdochost 
    if node.attribute?('realdocproxy')
      rdochost = node[:realdocproxy]
    else
      rdochost = {}
      search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
        rdochost[n.ipaddress] = {}
      end
      rdochost = rdochost.first
    end
    push(rdochost)
  end
  def self.l1cenhost
    if node.attribute?('l1cenproxy')
      l1cenhost = node[:l1cenproxy]
    else
      l1cenhost = {}
      search(:node, "role:l1-cen AND chef_environment:#{node.chef_environment}") do |n|
        l1cenhost[n.ipaddress] = {}
      end
    l1cenhost = l1cenhost.first
    end
    push(l1cenhost)
  end
  def self.amqphost
    if node.attribute?('amqpproxy')
      amqphost = node[:amqpproxy]
      amqpport = node[:amqpport]
    else
      amqphost = {}
      search(:node, "role:rabbitserver") do |n|
        amqphost[n.ipaddress] = {}
      end
      amqphost = amqphost.first
      amqpport = "5672"
    end
    push(amqphost)
    push(amqpport)
  end
end

