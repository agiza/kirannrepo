
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

appnames = "realfoundation"
# Create an array of all environments with realtrans workers installed
rfenvirons = []
appnames.split(" ").each do |app|
  Chef::Log.info("working on #{app}")
  search(:node, "recipes:*\\:\\:#{app}").each do |node|
    Chef::Log.info("found #{node}")
    rfenvirons << "#{node.chef_environment}"
    Chef::Log.info("#{node.chef_environment} added.")
  end
end
rfenvirons = rfenvirons.collect { |rfenviron| "#{rfenviron}" }.uniq
rfenvirons = rfenvirons.sort.uniq
Chef::Log.info("Use #{rfenvirons}")

if rfenvirons.nil? || rfenvirons.empty?
  Chef::Log.info("No realfoundation nodes in this environment found in search.")
else
  # Convert the hash list of environments into unique values
#  rfenvirons = rfenvirons.sort.uniq

  # Databag item for webserver hostname
  webName = data_bag_item("infrastructure", "apache")
  if node.attribute?('ssl_force')
    ssl = ".ssl"
  else
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rfenvirons.each do |environ|
    begin
    rfworkers = search(:node, "recipes:*\\:\\:realfoundation AND chef_environment:#{environ}")
    rescue Net::HTTPServerException
      raise "Unable to find realfoundation workers in #{environ}"
    end
    rfNames = []
    rfworkers.each do |worker|
      rfNames << worker['ipaddress']
    end
    template "/etc/httpd/proxy.d/rf-#{environ}.proxy.conf" do
      source "rf.proxy.conf.erb"
      owner "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostRfWorkers => rfNames,
        :environ => "#{environ}",
        :serveripallow => serveripallow
      )
    end
    template "/etc/httpd/conf.d/rf-#{environ}.vhost.conf" do
      source "rfvhost#{ssl}.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostName => "#{environ}",
        :testvhostName => webName["rf#{environ}"],
        :serverName => webName["rf#{environ}"]
      )
    end
    directory "/var/www/html/#{environ}" do
      owner "root"
      group "root"
    end
  end
end


