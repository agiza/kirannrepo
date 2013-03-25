#
# Cookbook Name:: altisource
# Definition:: l1cenhost_search
#

define :l1cenhost_search do
  
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  if node.attribute?('l1cenproxy')
    l1cenhost = node[:l1cenproxy].split(":")[0]
    l1cenport = node[:l1cenproxy].split(":")[1]
  else
    l1cenhost = []
    appdata["l1-central"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
        l1cenhost << worker
      end
    end
    if l1cenhost.nil? || l1cenhost.empty?
      Chef::Log.warn("No l1-central servers returned from search.") && l1cenhost = "No servers found."
    else
      l1cenhostip = []
      l1cenhost.each do |l1cenhost|
        l1cenhostip << l1cenhost["ipaddress"]
      end
      l1cenhost = l1cenhostip.sort.first
      l1cenport = "8080"
    end
  end

  node.default.l1cenhost = l1cenhost
  node.default.l1cenport = l1cenport

end

