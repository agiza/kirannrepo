#
# Cookbook Name:: apache
# Recipe:: l1vhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
# Create a hash of all environments with lendersone installed
l1cenenvirons = {}
search(:node, "role:l1-cen") do |n|
  l1cenenvirons[n.chef_environment] = {}
end

if l1cenenvirons.nil? || l1cenenvirons.empty?
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
  l1cenenvirons = l1cenenvirons.collect { |l1cenenviron| "#{l1cenenviron}" }.join(" ").split.uniq.join(" ").split(" ")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  l1cenenvirons.each do |environ|
    cenNames = {}
    search(:node, "role:l1-cen AND chef_environment:#{environ}") do |n|
      cenNames[n.ipaddress] = {}
    end
    venNames = {}
    search(:node, "role:l1-ven AND chef_environment:#{environ}") do |n|
      venNames[n.ipaddress] = {}
    end
    l1intNames = {}
    search(:node, "role:l1-integration AND chef_environment:#{environ}") do |n|
      l1intNames[n.ipaddress] = {}
    end
    #cenNames = search(:node, "role:l1-cen AND chef_environment:#{environ}")
    #cenNames = cenNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
    template "/etc/httpd/proxy.d/l1-#{environ}.proxy.conf" do
      source "l1.proxy.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostCenWorkers => cenNames,
        :l1intWorkers => l1intNames,
        :vhostName => "#{environ}",
        :environ => "#{environ}",
        :serveripallow => serveripallow
    )
    end
    template "/etc/httpd/conf.d/l1-#{environ}.vhost.conf" do
      source "l1vhost#{ssl}.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostName => "#{environ}",
        :serverName => webName["l1#{environ}"]
      )
    end
    directory "/var/www/html/#{environ}" do
      owner "root"
      group "root"
    end
    template "/etc/httpd/conf.d/corelogic-#{environ}.conf" do
      owner  "root"
      group  "root"
      mode   "0644"
      variables(
        :l1intservers => l1intNames
      )
      notifies :reload, resources(:service => "httpd")
    end
    template "/etc/httpd/conf.d/datavision-#{environ}.conf" do
      owner  "root"
      group  "root"
      mode   "0644"
      variables(
        :l1intservers => l1intNames
      )
      notifies :reload, resources(:service => "httpd")
    end
  end
end


