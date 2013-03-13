#
# Cookbook Name:: apache
# Recipe:: l1vhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
# Create a hash of all environments with lendersone installed
appnames = "l1-fp l1-rp l1-server int-corelogic"
# Create an array of all environments with realtrans workers installed
l1environs = []
appnames.split(" ").each do |app|
  Chef::Log.info("working on #{app}")
  search(:node, "recipes:*\\:\\:#{app}").each do |node|
    Chef::Log.info("found #{node}")
    l1environs << "#{node.chef_environment}" unless node.nil? || node.empty?
    Chef::Log.info("#{node.chef_environment} added.")
  end
end
l1environs = l1environs.collect { |l1environ| "#{l1environ}" }.uniq
l1environs = l1environs.sort.uniq
Chef::Log.info("Use #{l1environs}")

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

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  l1environs.each do |environ|
    begin
      rpworkers = search(:node, "recipes:*\\:\\:l1-rp AND chef_environment:#{environ}" || "recipes:*\\:\\:l1-server AND chef_environment:#{environ}")
      rescue Net::HTTPServerException
        raise "Unable to find l1-rp workers in #{environ}"
    end
    rpnames = rpworkers.map {|n| n["ipaddress"]} unless rpworkers.nil? || rpworkers.empty?
    begin
      fpworkers = search(:node, "recipes:*\\:\\:l1-fp AND chef_environment:#{environ}" || "recipes:*\\:\\:l1-server AND chef_environment:#{environ}")
      rescue Net::HTTPServerException
        raise "Unable to find l1-fp workers in #{environ}"
    end
    fpnames = fpworkers.map {|n| n["ipaddress"]} unless fpworkers.nil? || fpworkers.empty?
    begin
      intworkers = search(:node, "recipes:*\\:\\:int-corelogic AND chef_environment:#{environ}")
      rescue Net::HTTPServerException
        raise "Unable to find integration l1 workers in #{environ}"
    end
    intnames = intworkers.map {|n| n["ipaddress"]} unless intworkers.nil? || intworkers.empty?
    template "/etc/httpd/proxy.d/l1-#{environ}.proxy.conf" do
      source "l1.proxy.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :rpworkers => rpnames,
        :fpworkers => fpnames,
        :intworkers => intnames,
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


