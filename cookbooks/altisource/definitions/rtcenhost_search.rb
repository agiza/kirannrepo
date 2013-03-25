#
# Cookbook Name:: altisource
# Definition:: rtcenhost_search
#

define :rtcenhost_search do
  
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  # This looks for rt central proxy attribute or finds the first server itself.
  if node.attribute?('rtcenproxy')
    rtcenhost = node[:rtcenproxy].split(":")[0]
    rtcenport = node[:rtcenproxy].split(":")[1]
  else
    rtcenhost = []
    appdata["realtrans-central"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
        rtcenhost << worker
      end
    end
    if rtcenhost.nil? || rtcenhost.empty?
      Chef::Log.warn("No realtrans-central servers returned from search.") && rtcenhost = "No servers found."
    else
      rtcenhostip = []
      rtcenhost.each do |rtcenhost|
        rtcenhostip << rtcenhost["ipaddress"]
      end
      rtcenhost = rtcenhostip.sort.first
      rtcenport = "8080"
    end
  end

  node.default.rtcenhost = rtcenhost
  node.default.rtcenport = rtcenport

end

