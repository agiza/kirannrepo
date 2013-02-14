#
# Cookbook Name:: apache
# Recipe:: rtvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
# Create a hash of all environments with realtrans installed
rtcenenvirons = {}
search(:node, "recipes:realtrans\\:\\:realtrans-central OR role:realtrans-cen") do |n|
  rtcenenvirons[n.chef_environment] = {}
end

rtvenenvirons = {}
search(:node, "recipes:realtrans\\:\\:realtrans-vp OR role:realtrans-ven") do |n|
  rtvenenvirons[n.chef_environment] = {}
end

if rtcenenvirons.nil? || rtcenenvirons.empty?
  Chef::Log.info("No services returned from search.")
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
  rtcenenvirons = rtcenenvirons.collect { |rtcenenviron| "#{rtcenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

  # Convert the hash list of environments into a string, unique values, then split
  rtvenenvirons = rtvenenvirons.collect { |rtvenenviron| "#{rtvenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rtcenenvirons.each do |environ|
    fpnames = []
    rpnames = []
    vpnames = []
    regnames = []
    search(:node, "recipes:realtrans\\:\\:realtrans-fp AND chef_environment:#{environ}") do |worker|
      fpnames << worker["ipaddress"]
    end
    search(:node, "recipes:realtrans\\:\\:realtrans-rp AND chef_environment:#{environ}") do |worker|
      rpnames << worker["ipaddress"]
    end
    search(:node, "recipes:realtrans\\:\\:realtrans-vp AND chef_environment:#{environ}") do |worker|
      vpnames << worker["ipaddress"]
    end
    search(:node, "recipes:realtrans\\:\\:realtrans-reg AND chef_environment:#{environ}") do |worker|
      regnames << worker["ipaddress"]
    end
      
    #cenNames = {}
    #search(:node, "recipes:realtrans\\:\\:realtrans-central OR role:realtrans-cen AND chef_environment:#{environ}") do |n|
    #  cenNames[n.ipaddress] = {}
    #end
    #venNames = {}
    #search(:node, "recipes:realtrans\\:\\:realtrans-vp OR role:realtrans-ven AND chef_environment:#{environ}") do |n|
    #  venNames[n.ipaddress] = {}
    #end 
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
        #:vhostCenWorkers => cenNames,
        #:vhostVenWorkers => venNames,
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


