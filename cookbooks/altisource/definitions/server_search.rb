#
# Cookbook Name:: altisource
# Definition:: server_search
#

define :server_search do
  
  target = "#{params[:name]}"
  targetname = "#{params[:target]}"
  environment = "#{params[:environment]}"
  begin
    appdata = data_bag_item("infrastructure", "applications")
      rescue Net::HTTPServerException
        raise "No application names found in infrastructure data bag."
  end
  target = []
  appdata["appnames"][:targetname].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{environment}").each do |worker|
      target << worker["ipaddress"]
    end
  end
  target = target.sort.first
  node.default.target = target
end

