#
# Cookbook Name:: altisource
# Definition:: rfhost_search
#

define :rfhost_search do
  
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  if node.attribute?('rfproxy')
    rfhost = node[:rfproxy].split(":")[0]
    rfport = node[:rfproxy].split(":")[1]
  else
    rfhost = []
    appdata["realfoundation"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
        rfhost << worker
      end
    end
    if rfhost.nil? || rfhost.empty?
      Chef::Log.warn("No realfoundation servers found.") && rfhost = "No servers found."
    else
      rfhostip = []
      rfhost.each do |rfhost|
        rfhostip << rfhost["ipaddress"]
      end
      rfhost = rfhostip.sort.first
      rfport = "8080"
    end
  end
  Chef::Log.info("Realfoundation host is set to #{rfhost}")
  node.default.rfhost = rfhost
  node.default.rfport = rfport

end

