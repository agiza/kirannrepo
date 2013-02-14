#
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# Create a hash of all environments with realfoundationapp installed
rdenvirons = {}
search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc") do |n|
  rdenvirons[n.chef_environment] = {}
end

if rdenvirons.nil? || rdenvirons.empty?
  Chef::Log.info("No services returned from search.")
else
  # Convert the hash list of environments into unique values
  rdenvirons = rdenvirons.collect { |rdenviron| "#{rdenviron}" }.uniq

  # Databag item for webserver hostname
  webName = data_bag_item("infrastructure", "apache")
  if node.attribute?('ssl_force')
    ssl = ".ssl"
  else
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rdenvirons.each do |environ|
    rdNames = []
    search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc AND chef_environment:#{environ}") do |n|
      rdNames << n["ipaddress"]
    end
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
      source "rdvhost#{ssl}.conf.erb"
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


