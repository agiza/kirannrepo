#
# Cookbook Name:: apache
# Recipe:: l1vhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
# Create a hash of all environments with lendersone installed
l1environs = {}
%w[l1-fp l1-rp].each do |app|
  search(:node, "recipes:l1\\:\\:#{app}") do |node|
    l1environs[node.chef_environment] = {}
  end
end

if l1environs.nil? || l1environs.empty?
  Chef::Log.info("No lenders one apps found in search of this environment.")
else
  # Databag item for webserver hostname
  webName = data_bag_item("infrastructure", "apache")
  if node.attribute?('ssl_force')
    ssl = ".ssl"
  else 
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")

  # Convert the hash list of environments into unique values
  l1environs = l1environs.collect { |l1environ| "#{l1environ}" }.uniq

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  l1environs.each do |environ|
    l1rpnames = []
    l1fpnames = []
    search(:node, "recipes:l1\\:\\:l1-fp AND chef_environment:#{environ}").each do |worker|
      l1fpnames << worker["ipaddress"]
    end
    search(:node, "recipes:l1\\:\\:l1-rp AND chef_environment:#{environ}").each do |worker|
      l1rpnames << worker["ipaddress"]
    end
    l1intnames = []
    search(:node, "recipes:integration\\:\\:l1-corelogic AND chef_environment:#{environ}").each do |worker|
      l1intnames << worker["ipaddress"]
    end
    template "/etc/httpd/proxy.d/l1-#{environ}.proxy.conf" do
      source "l1.proxy.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :rpworkers => l1rpnames,
        :fpworkers => l1fpnames,
        :intworkers => l1intnames,
        :vhostName => "#{environ}",
        :environ => "#{environ}",
        :serveripallow => serveripallow
    )
    end
    template "/etc/httpd/conf.d/l1-#{environ}.vhost.conf" do
      source "l1vhost#{ssl}.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostName => "#{environ}",
        :serverName => webName["l1#{environ}"]
      )
    end
    directory "/var/www/html/#{environ}" do
      owner "root"
      group "root"
    end
  end
end


