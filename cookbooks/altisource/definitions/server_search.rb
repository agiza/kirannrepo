#
# Cookbook Name:: altisource
# Definition:: server_search
#

define :server_search do
  
  target = "#{params[:name]}"
  Chef::Log.info("target is #{target}")
  targetnames = "#{params[:targetnames]}".split(" ")
  Chef::Log.info("targetnames is #{targetnames}")
  workerip = []
  targetnames.each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{params[:environment]}").each do |worker|
    Chef::Log.info("Search was for #{app} in environment #{params[:environment]} and found #{worker["ipaddress"]}")
      workerip << worker["ipaddress"]
    end
  end
  workerip = workerip.sort.first
  Chef::Log.info("node entry is for #{workerip}")
  node.default.target = workerip
  Chef::Log.info("node default for #{target} was set to #{workerip}")
end

