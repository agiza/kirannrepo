#
# Cookbook Name:: altisource
# Definition:: server_search
#

define :server_search do
  
  target = "#{params[:name]}"
  begin
    appdata = data_bag_item("infrastructure", "applications")
      rescue Net::HTTPServerException
        raise "No application names found in infrastructure data bag."
  end
  if appdata.nil? || appdata.empty?
    Chef::Log.fatal("appdata is not available.")
  end
  target = []
  appdata["appnames"]["#{params[:target]}"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{params[:environment]}").each do |worker|
      target << worker["ipaddress"]
    end
  end
  target = target.sort.first
  node.default.target = target
end

