#
# Cookbook Name:: apache
# Recipe:: l1vhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
appnames = %w(l1-fp l1-rp l1-server int-corelogic)
# Create an array of all environments with realtrans workers installed
l1environs = []
appnames.each do |app|
  search(:node, "recipes:*\\:\\:#{app}").each do |node|
    l1environs << "#{node.chef_environment}"
  end
end
l1environs = l1environs.sort.uniq

if l1environs.nil? || l1environs.empty?
  Chef::Log.info("No lenders one apps found in search of this environment.")
else
  # Databag item for webserver hostname
  begin 
    webName = data_bag_item("infrastructure", "apache")
      rescue Net::HTTPServerException
        raise "Error loading apache information from infrastructure data bag."
  end
  serveripallow = %w(webName['serveripallow'])

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  l1environs.each do |environ|
    rpnames = []
    fpnames = []
    intnames = []
    %w{l1-rp l1-server}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |worker|
        rpnames << worker['ipaddress']
      end
    end
    %w{l1-fp l1-server}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |worker|
        fpnames << worker['ipaddress']
      end
    end
    %w{int-corelogic l1-int}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |worker|
        intnames << worker['ipaddress']
      end
    end
    rpnames = rpnames.sort.uniq
    fpnames = fpnames.sort.uniq
    intnames = intnames.sort.uniq
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
      source "l1vhost.conf.erb"
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
