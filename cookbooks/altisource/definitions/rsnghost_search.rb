#
# Cookbook Name:: altisource
# Definition:: rsnghost_search
#

define :rsnghost_search do
  
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  if node.attribute?('rsngproxy')
    rsnghost = node[:rsngproxy].split(":")[0]
    rsngport = node[:rsngproxy].split(":")[1]
  else
    rsnghost = []
    appdata["rsng"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
        rsnghost << worker
      end
    end
    if rsnghost.nil? || rsnghost.empty?
      Chef::Log.info("No rsng servers returned from search.")
    else
      rsnghostip = []
      rsnghost.each do |rsnghost|
        rsnghostip << rsnghost["ipaddress"]
      end
      rsnghost = rsnghostip.sort.first
      rsngport = "8080"
    end
  end

  node.default.rsnghost = rsnghost
  node.default.rsngport = rsngport

end

