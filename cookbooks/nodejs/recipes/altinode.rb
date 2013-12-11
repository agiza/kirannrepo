#
# Cookbook Name:: nodejs
# Recipe:: altinode
#

include_recipe "nodejs::install_from_binary"

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
