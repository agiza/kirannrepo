#
# Cookbook Name:: apache
# Recipe:: rtvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
# Create a hash of all environments with realtrans installed
rtenvirons = {}
%w[realtrans-rp realtrans-fp realtrans-vp realtrans-reg].each do |app|
  search(:node, "recipes:realtrans\\:\\:#{app}").each do |node|
    rtenvirons[node.chef_environment] = {}
  end
end

if rtenvirons.nil? || rtenvirons.empty?
  Chef::Log.info("No realtrans installations in this environment found in search.")
else
  # Databag item for webserver hostname
  webName = data_bag_item("infrastructure", "apache")
  if node.attribute?('ssl_force')
    ssl = ".ssl"
  else
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")

  # Convert the hash list of environments into a string, unique values, then split
  rtenvirons = rtenvirons.collect { |rtenviron| "#{rtenviron}" }.uniq

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rtenvirons.each do |environ|
    fpworkers = search(:node, "recipes:*\\:\\:realtrans-fp AND chef_environment:#{environ}" || "recipes:*\\:\\:realtrans-server AND chef_environment:#{environ}")
    fpnames = fpworkers["ipaddress"].sort.uniq
    rpworkers = search(:node, "recipes:*\\:\\:realtrans-rp AND chef_environment:#{environ}" || "recipes:*\\:\\:realtrans-server AND chef_environment:#{environ}")
    rpnames = rpworkers["ipaddress"].sort.uniq
    vpworkers = search(:node, "recipes:*\\:\\:realtrans-vp AND chef_environment:#{environ}" || "recipes:*\\:\\:realtrans-server AND chef_environment:#{environ}")
    vpnames = vpworkers["ipaddress"].sort.uniq
    regworkers = search(:node, "recipes:*\\:\\:realtrans-reg AND chef_environment:#{environ}" || "recipes:8\\:\\:realtrans-server AND chef_environment:#{environ}")
    vpnames = vpworkers["ipaddress"].sort.uniq
#    fpnames = []
#    rpnames = []
#    vpnames = []
#    regnames = []
#    search(:node, "recipes:*\\:\\:realtrans-fp OR realtransfp_version:* AND chef_environment:#{environ}").each do |worker|
#      fpnames << worker["ipaddress"]
#    end
#    search(:node, "recipes:*\\:\\:realtrans-rp OR realtransrp_version:* AND chef_environment:#{environ}").each do |worker|
#      rpnames << worker["ipaddress"]
#    end
#    search(:node, "recipes:*\\:\\:realtrans-vp OR realtransvp_version:* AND chef_environment:#{environ}").each do |worker|
#      vpnames << worker["ipaddress"]
#    end
#    search(:node, "recipes:*\\:\\:realtrans-reg OR realtransreg_version:* AND chef_environment:#{environ}").each do |worker|
#      regnames << worker["ipaddress"]
#    end
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


