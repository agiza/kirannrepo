#
# Cookbook Name:: apache
# Recipe:: rtvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

appnames = %w(realtrans-reg realtrans-vp realtrans-server)
# Create an array of all environments with realtrans workers installed
rtenvirons = []
appnames.each do |app|
  Chef::Log.debug("working on #{app}")
  search(:node, "recipes:*\\:\\:#{app}").each do |node|
    Chef::Log.debug("found #{node}")
    rtenvirons << "#{node.chef_environment}"
    Chef::Log.debug("#{node.chef_environment} added.")
  end
end
#rtenvirons = rtenvirons.collect { |rtenviron| "#{rtenviron}" }.uniq
rtenvirons = rtenvirons.sort.uniq
Chef::Log.debug("Use #{rtenvirons}")

if rtenvirons.nil? || rtenvirons.empty?
  Chef::Log.info("No realtrans installations found in any environment.")
else
  # Databag item for webserver hostname
  begin
    webName = data_bag_item("infrastructure", "apache")
      rescue Net::HTTPServerException
        raise "Error trying to pull apache information from infrastructure data bag."
  end
  serveripallow = webName['serveripallow']
  rtenvirons.each do |environ|
    # Loop through list of environments to build workers and pass to the vhost/proxy templates
    fpnames = []
    rpnames = []
    vpnames = []
    regnames = []
    %w{realtrans-vp realtrans-server}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |vworker|
        vpnames << vworker["ipaddress"]
      end
    end
    %w{realtrans-reg realtrans-server}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |reworker|
        regnames << reworker["ipaddress"]
      end
    end
    fpnames = fpnames.sort.uniq
    rpnames = rpnames.sort.uniq
    vpnames = vpnames.sort.uniq
    regnames = regnames.sort.uniq
    template "/etc/httpd/proxy.d/rte-#{environ}.proxy.conf" do
      source "rte.proxy.conf.erb"
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
    template "/etc/httpd/conf.d/rte-#{environ}.vhost.conf" do
      source "rtevhost.conf.erb"
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
