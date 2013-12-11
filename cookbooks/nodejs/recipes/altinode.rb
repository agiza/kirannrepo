#
# Cookbook Name:: nodejs
# Recipe:: altinode
#

"nodejs" => {
	"install_method" => "source",
	"version" => "0.10.15",
	"npm" => "1.2.18",
	"check_sha" => false
      }

include_recipe "nodejs::install_from_source"
include_recipe "nodejs::npm"

execute "npm install -g grunt-cli " do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "npm install -g grunt-cli"
  cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  not_if {::File.exists?("#{node['nodejs']['dir']}/bin/grunt") }
 }
end

execute "npm install -g bower " do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "npm install -g bower"
  cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  not_if {::File.exists?("#{node['nodejs']['dir']}/bin/bower") }
 }
end
