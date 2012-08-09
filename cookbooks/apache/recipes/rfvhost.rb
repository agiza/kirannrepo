#
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# Create a hash of all environments with realfoundationapp installed
rfenvirons = {}
search(:node, "role:realfoundationapp") do |n|
  rfenvirons[n.chef_environment] = {}
end

# Convert the hash list of environments into a string, unique values, then split
rfenvirons = rfenvirons.collect { |rfenviron| "#{rfenviron}" }.join(" ")
rfenvirons = rfenvirons.split.uniq.join(" ")
rfenvirons = rfenvirons.split(" ")

# Loop through list of environments to build workers and pass to the vhost/proxy templates
rfenvirons.each do |environ|
  rfNames = search(:node, "role:realfoundationapp AND chef_environment:#{environ}")
  rfNames = rfNames.collect { |vhostName| "#{vhostName}" }.join(" ")
  rfNames = rfNames.gsub!("node[","")
  rfNames = rfNames.gsub!(".#{node[:domain]}]","")
  rfNames = rfNames.split(" ")
  rfVhostName = {}
  rfVhostName = search(:node, "role:realfoundationapp AND chef_environment:#{environ}")
  rfVhostName = rfVhostName[n.web_server_hostname]
  rfVhostName = rfVhostName.collect { |name| "#{name}"}.split.uniq()
  template "/etc/httpd/proxy.d/rf-#{environ}.proxy.conf" do
    source "rf.proxy.conf.erb"
    owner "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    variables(
      :vhostRfWorkers => rfNames,
      :environ => "#{environ}"
    )
  end
  template "/etc/httpd/conf.d/rf-#{environ}.vhost.conf" do
    source "rfvhost.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    case "#{environ}"
    when "Dev"
      variables(
        :vhostName => "#{environ}",
        :serverName => rfVhostName
      )
    when "QA"
      variables(
        :vhostName => "#{environ}",
        :serverName => rfVhostName
      )
    else
      variables(
      :vhostName => "#{environ}",
      :serverName => rfVhostName
    )
    end
  end

  directory "/var/www/html/#{environ}" do
    owner "root"
    group "root"
  end
end

