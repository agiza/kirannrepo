#
# Cookbook Name:: altisource
# Definition:: rdochost_search
#

define :rdochost_search do
  
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  # This looks for realdoc proxy attribute and allows override of realdoc server or finds the first server itself
  if node.attribute?('realdocproxy')
    rdochost = node[:realdocproxy].split(":")[0]
    rdocport = node[:realdocproxy].split(":")[1]
  else
    rdochost = []
    appdata["realdoc"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
        rdochost << worker
      end
    end
    if rdochost.nil? || rdochost.empty?
      Chef::Log.warn("No realdoc servers returned from search.") && rdochost = "No servers found."
    else
      rdochostip = []
      rdochost.each do |rdochost|
        rdochostip << rdochost["ipaddress"]
      end
      rdochost = rdochostip.sort.first
      rdocport = "8080"
    end
  end
  Chef::Log.info("Realdoc host is set to #{rdochost}.")
  node.default.rdochost = rdochost
  node.default.rdocport = rdocport

end

