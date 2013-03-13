#
# Cookbook Name:: apache
# Recipe:: rtvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

appnames = "realtrans-fp realtrans-rp realtrans-reg realtrans-vp realtrans-server"
# Create an array of all environments with realtrans workers installed
rtenvirons = []
appnames.split(" ").each do |app|
  Chef::Log.info("working on #{app}")
  search(:node, "recipes:*\\:\\:#{app}").each do |node|
    Chef::Log.info("found #{node}")
    rtenvirons << "#{node.chef_environment}"
    Chef::Log.info("#{node.chef_environment} added.")
  end
end
rtenvirons = rtenvirons.collect { |rtenviron| "#{rtenviron}" }.uniq
rtenvirons = rtenvirons.sort.uniq
Chef::Log.info("Use #{rtenvirons}")

if rtenvirons.nil? || rtenvirons.empty?
  Chef::Log.info("No realtrans installations found in any environment.")
else
  # Databag item for webserver hostname
  webName = data_bag_item("infrastructure", "apache")
  if node.attribute?('ssl_force')
    ssl = ".ssl"
  else
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")
  rtenvirons.each do |environ|
    # Loop through list of environments to build workers and pass to the vhost/proxy templates
    fpnames = []
    rpnames = []
    vpnames = []
    regnames = []
    search(:node, "recipes:*\\:\\:realtrans-fp AND chef_environment:#{environ}" || "recipes:*\\:\\:realtrans-server AND chef_environment:#{environ}").each do |fworker|
      fpnames << fworker['ipaddress']
    end
    search(:node, "recipes:*\\:\\:realtrans-rp AND chef_environment:#{environ}" || "recipes:*\\:\\:realtrans-server AND chef_environment:#{environ}").each do |rworker|
      rpnames << rworker['ipaddress']
    end
    search(:node, "recipes:*\\:\\:realtrans-vp AND chef_environment:#{environ}" || "recipes:*\\:\\:realtrans-server AND chef_environment:#{environ}").each do |vworker|
      vpnames << vworker['ipaddress']
    end
    search(:node, "recipes:*\\:\\:realtrans-reg AND chef_environment:#{environ}" || "recipes:*\\:\\:realtrans-server AND chef_environment:#{environ}").each do |reworker|
      regnames << reworker['ipaddress']
    end
    fpnames = fpnames.sort.uniq
    rpnames = rpnames.sort.uniq
    vpnames = vpnames.sort.uniq
    regnames = regnames.sort.uniq
    template "/etc/httpd/proxy.d/rt-#{environ}.proxy.conf" do
      source "rt.proxy.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :fpworkers => fpnames,
        :rpworkers => rpnames,
        :vpworkers => vpnames,
        :regworkers => regnames,
        :vhostName => "#{environ}",
        :environ => "#{environ}",
        :serveripallow => serveripallow
      )
    end
    template "/etc/httpd/conf.d/rt-#{environ}.vhost.conf" do
      source "rtvhost#{ssl}.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostName => "#{environ}",
        :serverName => webName["rt#{environ}"]
      )
    end
    directory "/var/www/html/#{environ}" do
      owner "root"
      group "root"
    end
  end
end
