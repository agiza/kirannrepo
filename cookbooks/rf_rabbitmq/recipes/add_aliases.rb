
cookbook_file '/tmp/add_host.sh' do
  source 'add_host.sh'
  mode 0755
end

#Search all the chef nodes from the same environment the current is in and add them in /etc/hosts
#This will be useful for example for installing RabbitMQ as a cluster, when slaves need to know the master hostname

chefNodes = search(:node, "chef_environment:#{node.chef_environment}")
chefNodes.each do |node|
  execute "install add_host.sh" do
    Chef::Log.info("Adding alias #{node['ipaddress']}:#{node['fqdn']}")
    command "sh /tmp/add_host.sh #{node['ipaddress']} #{node['fqdn']}"
  end
end