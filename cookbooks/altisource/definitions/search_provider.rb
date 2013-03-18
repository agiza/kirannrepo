#
# Cookbook Name:: altisource
# Definition:: search_provider
#

define :search_provider, :name => params[:name], :appnames => params[:appnames], :environment => params[:environment], :port => params[:port] do
 name_attribute = "#{params[:name]}"
 name_port = "#{params[:port]}"
 workerip = []
  appnames["#{params[:appnames]}"].split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{params[:environment]}".each do |worker|
      workerip << worker["ipaddress"]
    end
  end
  if workerip.nil? || workerip.empty?
    Chef::Log.warn("No #{params[:name]} servers found in search.") && workerip = "No servers found."
  else
    workername = workerip.sort.first
    #params[:port] = params[:port]
  end
  node.default.name_attribute = "#{workerip}"
  node.default.name_port = "#{params[:port]}"
end
