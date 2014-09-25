#
# Cookbook Name:: rf-hosts
# Recipe:: default


cookbook_file '/tmp/add_host.sh' do
  source 'add_host.sh'
  mode 0755
end

#Search all the chef nodes from the same environment the current is in and add them in /etc/hosts
#This will be useful for example for installing RabbitMQ as a cluster, when slaves need to know the master hostname

chefNodes = search(:node, "chef_environment:#{node.chef_environment}")
chefNodes.each do |node|
  execute "install add_host.sh" do
    command "sh /tmp/add_host.sh #{node['ipaddress']} #{node['fqdn']}"
  end
end

#node['hosts_to_add']['hosts'].each do |host|
#  execute "install add_host.sh" do
#    command "sh /tmp/add_host.sh #{host['ip']} #{host['hostName']}"
#  end

#end
