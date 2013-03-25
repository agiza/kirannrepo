#
# Cookbook Name:: altisource
# Definition:: elastichost_search
#

define :elastichost_search do
  
  begin
    appnames = data_bag_item("infrastructure", "applications")
    rescue Net::HTTPServerException
      raise "No application names found in infrastructure data bag."
  end
  appdata = appnames["appnames"]

  if node.attribute?('elasticsearchproxy')
     elasticHost = node[:elasticsearchproxy]
  else
    elasticHost = []
    appdata["elasticsearch"].split(" ").each do |app|
      search(:node, "recipes:*\\:\\:#{app} AND chef_environment:#{node.chef_environment}").each do |worker|
        elasticHost << worker
      end
    end
    if elasticHost.nil? || elasticHost.empty?
      Chef::Log.warn("No elasticsearch servers returned from search.") && elasticHost = "No servers found."
    else
      elastichostip = []
      elasticHost.each do |elastichost|
        elastichostip << elastichost["ipaddress"]
      end
      elasticHost = elastichostip.sort.first
    end
  end
  node.default.elasticHost = elasticHost

end

