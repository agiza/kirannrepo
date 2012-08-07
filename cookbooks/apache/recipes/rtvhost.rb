#
# Cookbook Name:: apache
# Recipe:: rtvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

["Dev", "Intdev", "QA", "Demo"].each do |environ|
  cenNames = search(:node, "role:realtrans-cen AND chef_environment:#{environ}")
  cenNames = cenNames.collect { |vhostName| "#{vhostName}" }.join(" ")
  cenNames = cenNames.gsub!("node[","")
  cenNames = cenNames.gsub!(".#{node[:domain]}]","")
  cenNames = cenNames.split(" ")
  venNames = search(:node, "role:realtrans-ven AND chef_environment:#{environ}")
  venNames = venNames.collect { |vhostName| "#{vhostName}" }.join(" ")
  venNames = venNames.gsub!("node[","")
  venNames = venNames.gsub!(".#{node[:domain]}]","")
  venVenNames = venNames.split(" ")
  template "/etc/httpd/proxy.d/realtrans-#{environ}.proxy.conf" do
    source "realtrans.proxy.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
    variables(
      :vhostCenWorkers => cenNames,
      :vhostVenWorkers => venNames,
      :environ => "#{environ}"
    )
  end

  template "/etc/httpd/conf.d/#{environ}.vhost.conf" do
     source "vhost.conf.erb"
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


