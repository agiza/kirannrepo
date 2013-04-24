#
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

appnames = "realdoc realdoc-server"
# Create an array of all environments with realtrans workers installed
rdenvirons = []
appnames.split(" ").each do |app|
  #Chef::Log.info("working on #{app}")
  search(:node, "recipes:*\\:\\:#{app}").each do |node|
    #Chef::Log.info("found #{node}")
    rdenvirons << "#{node.chef_environment}"
    #Chef::Log.info("#{node.chef_environment} added.")
  end
end
#rdenvirons = rdenvirons.collect { |rdenviron| "#{rdenviron}" }.uniq
rdenvirons = rdenvirons.sort.uniq
#Chef::Log.info("Use #{rdenvirons}")

if rdenvirons.nil? || rdenvirons.empty?
  Chef::Log.info("No environments found with realdoc workers.")
else
  # Databag item for webserver hostname
  begin
    webName = data_bag_item("infrastructure", "apache")
      rescue Net::HTTPServerException
        raise "Error trying to load apache information from infrastructure data bag."
  end
  serveripallow = webName['serveripallow'].split("|")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rdenvirons.each do |environ|
    rdNames = []
    %w{realdoc realdoc-server}.each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environ}").each do |rdworker|
        rdNames << rdworker['ipaddress']
      end
    end
    rdNames =  rdNames.sort.uniq
    template "/etc/httpd/proxy.d/rd-#{environ}.proxy.conf" do
      source "rd.proxy.conf.erb"
      owner "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostRdWorkers => rdNames,
        :environ => "#{environ}",
        :serveripallow => serveripallow
      )
    end
    template "/etc/httpd/conf.d/rd-#{environ}.vhost.conf" do
      source "rdvhost.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostName => "#{environ}",
        :testvhostName => webName["rd#{environ}"],
        :serverName => webName["rd#{environ}"]
      )
    end
    directory "/var/www/html/#{environ}" do
      owner "root"
      group "root"
    end
  end
end

