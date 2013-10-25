#
# Cookbook Name:: infrastructure
# Recipe:: mongoup2date
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
yum_package "mongoup2date" do
  action :upgrade
end

# TODO: determine who these files should be owned by
template '/var/mongoup2date/mongoup2date.properties' do
  source 'mongoup2date.properties.erb'
  mode '0644'
  variables(
      :mongodb => node[:mongodb],
      :environment => "#{node.chef_environment}".downcase
  )
end