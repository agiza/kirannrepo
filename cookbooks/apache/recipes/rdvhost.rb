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
search(:node, "role:realdoc") do |n|
  rdenvirons[n.chef_environment] = {}
end

# Convert the hash list of environments into a string, unique values, then split
rdenvirons = rdenvirons.collect { |rdenviron| "#{rdenviron}" }.join(" ").split.uniq.join(" ").split(" ")

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

if rdenvirons == "nil"
  
else
  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rdenvirons.each do |environ|
    rdNames = search(:node, "role:realdoc AND chef_environment:#{environ}")
    rdNames = rdNames.collect { |vhostName| "#{vhostName}" }.join(" ").gsub!("node[","").gsub!(".#{node[:domain]}]","").split(" ")
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

