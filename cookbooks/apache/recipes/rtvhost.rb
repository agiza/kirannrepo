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

# Databag item for webserver hostname
webName = data_bag_item("apache-server", "webhost")

# Convert the hash list of environments into a string, unique values, then split
rtcenenvirons = rtcenenvirons.collect { |rtcenenviron| "#{rtcenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

# Convert the hash list of environments into a string, unique values, then split
rtvenenvirons = rtvenenvirons.collect { |rtvenenviron| "#{rtvenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

# Loop through list of environments to build workers and pass to the vhost/proxy templates
rtcenenvirons.each do |environ|
#["Dev", "Intdev", "QA", "Demo"].each do |environ|
  cenNames = search(:node, "role:realtrans-cen AND chef_environment:#{environ}")
  venNames = search(:node, "role:realtrans-ven AND chef_environment:#{environ}")
  cenNames = cenNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
  venNames = venNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
  template "/etc/httpd/proxy.d/realtrans-#{environ}.proxy.conf" do
    source "rt.proxy.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    variables(
      :vhostCenWorkers => cenNames,
      :vhostVenWorkers => venNames,
      :vhostName => "#{environ}",
      :environ => "#{environ}"
    )
  end

  template "/etc/httpd/conf.d/rt-#{environ}.vhost.conf" do
    source "rtvhost.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    #case "#{environ}"
    #when "Intdev"
    variables(
      :vhostName => "#{environ}",
      :serverName => webName["rt#{environ}"]
    )
    #when "QA"
    #  variables(
    #    :vhostName => "#{environ}",
    #    :serverName => "qa"
    #  )
    #when "Demo"
    #  variables(
    #    :vhostName => "#{environ}",
    #    :serverName => "demo"
    #  )
    #when "Dev"
    #  variables(
    #    :vhostName => "#{environ}",
    #    :serverName => "development"
    #  )
    #else
    #  variables(
    #    :vhostName => "#{environ}",
    #    :serverName => "#{environ}"
    #  )
    #end
  end

  directory "/var/www/html/#{environ}" do
    owner "root"
    group "root"
  end
end

