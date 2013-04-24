
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

appnames = %w(realfoundation)
# Create an array of all environments with realtrans workers installed
rfenvirons = []
appnames.split(" ").each do |app|
  search(:node, "recipes:*\\:\\:#{app}").each do |node|
    rfenvirons << "#{node.chef_environment}"
  end
end
rfenvirons = rfenvirons.sort.uniq

if rfenvirons.nil? || rfenvirons.empty?
  Chef::Log.info("No realfoundation nodes in this environment found in search.")
else
  # Convert the hash list of environments into unique values
#  rfenvirons = rfenvirons.sort.uniq

  # Databag item for webserver hostname
  begin
    webName = data_bag_item("infrastructure", "apache")
      rescue Net::HTTPServerException
        raise "Error loading apache information from infrastructure data bag."
  end
  if node.attribute?('ssl_force')
    ssl = ".ssl"
  else
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rfenvirons.each do |environ|
    rfNames = []
    rfworkers = search(:node, "recipes:*\\:\\:realfoundation AND chef_environment:#{environ}")
    rfworkers.each do |rfworker|
      rfNames << rfworker['ipaddress']
    end
    rfNames = rfNames.sort.uniq
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


