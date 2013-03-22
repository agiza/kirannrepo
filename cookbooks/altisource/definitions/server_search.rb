#
# Cookbook Name:: altisource
# Definition:: server_search
#

define :server_search do
  
  target = "#{params[:name]}"
  targetnames = "#{params[:targetnames]}"
  workerip = []
  targetnames.split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{params[:environment]}").each do |worker|
      workerip << worker["ipaddress"]
    end
  end
  workerip = workerip.sort.first
  node.default.target = workerip
  Chef::Log.info("node default for #{target} was set to #{workerip}")
end

