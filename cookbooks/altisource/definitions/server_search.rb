#
# Cookbook Name:: altisource
# Definition:: server_search
#

define :server_search do
  
  target = "#{params[:name]}"
  targetnames = params[:targetnames]
  target = []
  targetnames.each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{params[:environment]}").each do |worker|
      target << worker["ipaddress"]
    end
  end
  target = target.sort.first
  node.default.target = target
end

