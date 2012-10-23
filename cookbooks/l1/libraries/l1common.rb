# define a module to mix into Chef::Recipe
module l1commonLibrary
  def rdochost() 
    if node.attribute?('realdocproxy')
      rdochost = node[:realdocproxy]
    else
      rdochost = {}
      search(:node, "role:realdoc AND chef_environment:#{node.chef_environment}") do |n|
        rdochost[n.ipaddress] = {}
      end
      rdochost = rdochost.first
    end
  end
  def l1cenhost()
    if node.attribute?('l1cenproxy')
      l1cenhost = node[:l1cenproxy]
    else
      l1cenhost = {}
      search(:node, "role:l1-cen AND chef_environment:#{node.chef_environment}") do |n|
        l1cenhost[n.ipaddress] = {}
      end
    l1cenhost = l1cenhost.first
    end
  end
  def amqphost()
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
  end
end

