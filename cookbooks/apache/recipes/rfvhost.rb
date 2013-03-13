#
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# Create a hash of all environments with realfoundationapp installed
rfenvirons = {}
search(:node, "recipes:realfoundation\\:\\:realfoundation OR role:realfoundation") do |n|
  rfenvirons[n.chef_environment] = {}
end

if rfenvirons.nil? || rfenvirons.empty?
  Chef::Log.info("No realfoundation nodes in this environment found in search.")
else
  # Convert the hash list of environments into unique values
  rfenvirons = rfenvirons.collect { |rfenviron| "#{rfenviron}" }.uniq

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
    rfNames = []
    search(:node, "recipes:realfoundation\\:\\:realfoundation AND chef_environment:#{environ}").each do |worker|
      rfNames << worker["ipaddress"]
    end
    search(:node, "realfoundation_version:* AND chef_environment:#{environ}").each do |worker|
      rfNames << worker["ipaddress"]
    end
    template "/etc/httpd/proxy.d/rf-#{environ}.proxy.conf" do
      source "rf.proxy.conf.erb"
      owner "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostRfWorkers => rfNames.sort.uniq,
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


