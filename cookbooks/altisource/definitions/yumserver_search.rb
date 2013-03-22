#
# Cookbook Name:: altisource
# Definition:: yumserver_search
#

define :yumserver_search do

  if node.attribute?("yum_server")
       yumserver = node[:yum_server]
  else
    yumserver = []
    %w{yumserver yum-repo}.each do |app|
      search(:node, "recipes:*\\:\\:#{app}").each do |worker|
        yumserver << worker["ipaddress"]
      end
    end
    yumserver = yumserver.first
    node.default.yumserver = yumserver
  end
end

