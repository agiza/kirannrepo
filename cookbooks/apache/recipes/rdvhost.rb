#
# Cookbook Name:: apache
# Recipe:: rfvhost
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

# Create a hash of all environments with realfoundationapp installed
begin
  rdworkers = search(:node, "recipes:realdoc\\:\\:realdoc OR role:realdoc")
  rescue Net::HTTPServerException
    raise "No realdoc workers found in any environment."
end 
rdenvirons = rdworkers["chef_environment"] unless rdworkers["chef_environment"].nil? || rdworkers["chef_environment"].empty?

if rdenvirons.nil? || rdenvirons.empty?
  Chef::Log.info("No environments found with realdoc workers.")
else
  # Convert the hash list of environments into unique values
  rdenvirons = rdenvirons.sort.uniq

  # Databag item for webserver hostname
  webName = data_bag_item("infrastructure", "apache")
  if node.attribute?('ssl_force')
    ssl = ".ssl"
  else
    ssl = ""
  end
  serveripallow = webName['serveripallow'].split("|")

  # Loop through list of environments to build workers and pass to the vhost/proxy templates
  rdenvirons.each do |environ|
    begin
      rdNames = search(:node, "recipes:realdoc\\:\\:realdoc AND chef_environment:#{environ}" || "recipes:realdoc\\:\\:realdoc-server AND chef_environment:#{environ}")
      rescue Net::HTTPServerException
        raise "Unable to find realdoc workers in #{environ}"
    end
    rdNames = rdNames["ipaddress"] unless rdNames.nil? || rdNames.empty?
    template "/etc/httpd/proxy.d/rd-#{environ}.proxy.conf" do
      source "rd.proxy.conf.erb"
      owner "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
      variables(
        :vhostRdWorkers => rdNames.sort.uniq,
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


