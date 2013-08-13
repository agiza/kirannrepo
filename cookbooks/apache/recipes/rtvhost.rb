#
# Cookbook Name:: apache
# Recipe:: rtvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

appnames = %w(realtrans-fp realtrans-central realtrans-reg realtrans-vp realtrans-server)
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
    centralNames = []
    vpnames = []
    regnames = []
    %w{realtrans-fp realtrans-server}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |fworker|
        fpnames << fworker["ipaddress"]
      end
    end
    %w{realtrans-central realtrans-server}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |cworker|
        centralNames << cworker["ipaddress"]
      end
    end
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
    centralNames = centralNames.sort.uniq
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
        :centralworkers => centralNames,
        :vpworkers => vpnames,
        :regworkers => regnames,
        :vhostName => "#{environ}",
        :environ => "#{environ}",
        :serveripallow => serveripallow
      )
    end
    template "/etc/httpd/conf.d/rt-#{environ}.vhost.conf" do
      source "rtvhost.conf.erb"
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
