#
# Cookbook Name:: altisource
# Definition:: hzhost_search
#

define :hzhost_search do
  
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  if node.attribute?('hzproxy')
    hzhost = node[:hzproxy].split(":")[0]
    hzport = node[:hzproxy].split(":")[1]
  else
    hzhost = []
    appdata["hubzu"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
        hzhost << worker
      end
    end
    if hzhost.nil? || hzhost.empty?
      Chef::Log.warn("No hubzu servers found in search.") && hzhost = "No servers found."
    else
      hzhostip = []
      hzhost.each do |hzhost|
        hzhostip << hzhost["ipaddress"]
      end
      hzhost = hzhostip.sort.first
      hzport = "8080"
    end
  end
  Chef::Log.info("Hubzu host is set to #{hzhost}.")
  node.default.hzhost = hzhost
  node.default.hzort = hzport

end

