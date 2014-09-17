#
# Cookbook Name:: rf-hosts
# Recipe:: custom_hosts


cookbook_file '/tmp/add_host.sh' do
  source 'add_host.sh'
  mode 0755
end

#Edit the /etc/hosts file for a node, based on the attributes defined
node['hosts_to_add']['hosts'].each do |host|
  execute "install add_host.sh" do
    command "sh /tmp/add_host.sh #{host['ip']} #{host['hostName']}"
  end
end
