#
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

rfenvirons = {}
search(:node, "role:realfoundationapp") do |n|
  rfenvirons[n.chef_environment] = {}
end

rfenvirons = rfenvirons.collect { |rfenviron| "#{rfenviron}" }.join(" ")
rfenvirons = rfenvirons.split.uniq(" ")

template "/etc/httpd/conf.d/test-environment.txt" do
  source "test-environment.erb"
  owner  "root"
  group  "root"
  mode   "0664"
  variables(:environs => rfenvirons)
end

["Dev", "QA"].each do |environ|
  rfNames = search(:node, "role:realfoundationapp AND chef_environment:#{environ}")
  rfNames = rfNames.collect { |vhostName| "#{vhostName}" }.join(" ")
  rfNames = rfNames.gsub!("node[","")
  rfNames = rfNames.gsub!(".#{node[:domain]}]","")
  rfNames = rfNames.split(" ")
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
        :serverName => "rfdev"
      )
    when "QA"
      variables(
        :vhostName => "#{environ}",
        :serverName => "rfqa"
      )
    end
  end

  directory "/var/www/html/#{environ}" do
    owner "root"
    group "root"
  end
end

