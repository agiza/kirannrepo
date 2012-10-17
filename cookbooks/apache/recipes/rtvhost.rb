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
search(:node, "role:realtrans-cen") do |n|
  rtcenenvirons[n.chef_environment] = {}
end

rtvenenvirons = {}
search(:node, "role:realtrans-ven") do |n|
  rtvenenvirons[n.chef_environment] = {}
end

if rtcenenvirons.nil? || rtcenenvirons.empty?
  Chef::Log.info("No services returned from search.")
else
  # Databag item for webserver hostname
  webName = data_bag_item("apache-server", "webhost")
  sslflag = webName['sslflag']
  case "#{sslflag}"
  when "true"
    ssl = ".ssl"
  when "false", "nil"
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")

  # Convert the hash list of environments into a string, unique values, then split
  rtcenenvirons = rtcenenvirons.collect { |rtcenenviron| "#{rtcenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

  # Convert the hash list of environments into a string, unique values, then split
  rtvenenvirons = rtvenenvirons.collect { |rtvenenviron| "#{rtvenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rtcenenvirons.each do |environ|
    cenNames = {}
    search(:node, "role:realtrans-cen AND chef_environment:#{environ}") do |n|
      cenNames[n.ipaddress] = {}
    end
    venNames = {}
    search(:node, "role:realtrans-ven AND chef_environment:#{environ}") do |n|
      venNames[n.ipaddress] = {}
    end 
    #cenNames = search(:node, "role:realtrans-cen AND chef_environment:#{environ}")
    #venNames = search(:node, "role:realtrans-ven AND chef_environment:#{environ}")
    #cenNames = cenNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
    #venNames = venNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
    template "/etc/httpd/proxy.d/rt-#{environ}.proxy.conf" do
      source "rt.proxy.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostCenWorkers => cenNames,
        :vhostVenWorkers => venNames,
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


