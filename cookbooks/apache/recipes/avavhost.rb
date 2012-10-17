#
# Cookbook Name:: apache
# Recipe:: avavhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
# Create a hash of all environments with ava installed
avacenenvirons = {}
search(:node, "role:ava-cen") do |n|
  avacenenvirons[n.chef_environment] = {}
end

avavenenvirons = {}
search(:node, "role:ava-ven") do |n|
  avavenenvirons[n.chef_environment] = {}
end
unless avacenenvirons == "nil"
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
  avacenenvirons = avacenenvirons.collect { |avacenenviron| "#{avacenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

  # Convert the hash list of environments into a string, unique values, then split
  avavenenvirons = avavenenvirons.collect { |avavenenviron| "#{avavenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  avacenvirons.each do |environ|
    cenNames = {}
    search(:node, "role:ava-cen AND chef_environment:#{environ}") do |n|
      cenNames[n.ipaddress] = {}
    end
    venNames = {}
    search(:node, "role:ava-ven AND chef_environment:#{environ}") do |n|
      venNames[n.ipaddress] = {}
    end
  #  cenNames = search(:node, "role:ava-cen AND chef_environment:#{environ}")
  #  venNames = search(:node, "role:ava-ven AND chef_environment:#{environ}")
  #  cenNames = cenNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
  #  venNames = venNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
    template "/etc/httpd/proxy.d/ava-#{environ}.proxy.conf" do
      source "ava.proxy.conf.erb"
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
    template "/etc/httpd/conf.d/ava-#{environ}.vhost.conf" do
      source "avavhost#{ssl}.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostName => "#{environ}",
        :serverName => webName["ava#{environ}"]
      )
    end
     directory "/var/www/html/#{environ}" do
      owner "root"
      group "root"
    end
  end
end


