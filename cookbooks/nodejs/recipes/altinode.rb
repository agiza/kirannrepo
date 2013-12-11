#
# Cookbook Name:: nodejs
# Recipe:: altinode
#

nodejs = {
	"version" => "0.10.15",
	"npm" => "1.2.18",
	"check_sha" => false
      }

include_recipe "nodejs::install_from_binary"
include_recipe "nodejs::npm"

execute "npm install -g grunt-cli " do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "npm install -g grunt-cli"
  not_if {::File.exists?("#{node['nodejs']['dir']}/bin/grunt") }
end

execute "npm install -g bower " do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "npm install -g bower"
  not_if {::File.exists?("#{node['nodejs']['dir']}/bin/bower") }
end
