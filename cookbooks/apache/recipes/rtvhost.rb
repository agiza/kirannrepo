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

# Convert the hash list of environments into a string, unique values, then split
rtcenenvirons = rtcenenvirons.collect { |rtcenenviron| "#{rtcenenviron}" }.join(" ")
rtcenenvirons = rtcenenvirons.split.uniq.join(" ")
rtcenenvirons = rtcenenvirons.split(" ")

# Convert the hash list of environments into a string, unique values, then split
rtvenenvirons = rtvenenvirons.collect { |rtvenenviron| "#{rtvenenviron}" }.join(" ")
rtvenenvirons = rtvenenvirons.split.uniq.join(" ")
rtvenenvirons = rtvenenvirons.split(" ")

# Loop through list of environments to build workers and pass to the vhost/proxy templates
rtcenenvirons.each do |environ|
#["Dev", "Intdev", "QA", "Demo"].each do |environ|
  cenNames = search(:node, "role:realtrans-cen AND chef_environment:#{environ}")
  cenNames = cenNames.collect { |vhostName| "#{vhostName}" }.join(" ")
  cenNames = cenNames.gsub!("node[","")
  cenNames = cenNames.gsub!(".#{node[:domain]}]","")
  cenNames = cenNames.split(" ")
  template "/etc/httpd/proxy.d/realtrans-#{environ}-cen.proxy.conf" do
    source "rt-cen.proxy.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    variables(
      :vhostCenWorkers => cenNames,
      :vhostName => "#{environ}-cen",
      :environ => "#{environ}"
    )
  end

  template "/etc/httpd/conf.d/rt-#{environ}.vhost.conf" do
    source "rtvhost.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    case "#{environ}"
    when "Intdev"
      variables(
        :vhostName => "#{environ}",
        :serverName => "dev"
      )
    when "QA"
      variables(
        :vhostName => "#{environ}",
        :serverName => "qa"
      )
    when "Demo"
      variables(
        :vhostName => "#{environ}",
        :serverName => "demo"
      )
    when "Dev"
      variables(
        :vhostName => "#{environ}",
        :serverName => "development"
      )
    else
      variables(
        :vhostName => "#{environ}",
        :serverName => "#{environ}"
      )
    end
  end

  directory "/var/www/html/#{environ}" do
    owner "root"
    group "root"
  end
end


rtvenenvirons.each do |environ|
  venNames = search(:node, "role:realtrans-ven AND chef_environment:#{environ}")
  venNames = venNames.collect { |vhostName| "#{vhostName}" }.join(" ")
  venNames = venNames.gsub!("node[","")
  venNames = venNames.gsub!(".#{node[:domain]}]","")
  venVenNames = venNames.split(" ")
  template "/etc/httpd/proxy.d/realtrans-#{environ}-ven.proxy.conf" do
    source "rt-ven.proxy.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    variables(
      :vhostVenWorkers => venNames,
      :vhostName => "#{environ}-ven",
      :environ => "#{environ}"
    )
  end

  directory "/var/www/html/#{environ}" do
    owner "root"
    group "root"
  end
end

