#
# Cookbook Name:: altisource
# Definition:: search_provider
#

define :search_provider, :enable => true, :appnames => {}, :port => nil do
  params[:name] = []
  appnames["#{params[:appnames]}".split(" ").each do |app|
    search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{params[:environment]}".each do |worker|
      params[:name] << worker["ipaddress"]
    end
  end
  if params[:name].nil? || params[:name].empty?
    Chef::Log.warn("No #{params[:name]} servers found in search.") && params[:name] = "No servers found."
  else
    params[:name] = params[:name].sort.first
    params[:port] = params[:port]
  end
  node.default.params[:name] = params[:name]
  node.default.params[:port] = params[:port]
end
