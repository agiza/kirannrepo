#
# Cookbook Name:: hubzu
# Recipe:: hubzu-accounts
#
# Copyright 2013, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "hubzu-accounts"

begin
      accounts = data_bag_item("hubzu", "accounts#{node.chef_environment}")
        rescue Net::HTTPServerException
           raise "Unable to find hubzu-accounts environment specifc databag."
end

template "/opt/tomcat/conf/#{app_name}.properties" do
  source "#{app_name}.properties.erb"
  group 'tomcat'
  owner 'tomcat'
  mode '0644'
  notifies :restart, resources(:service => "altitomcat")
  variables( 
    :accounts => accounts["accounts"]
  )
end

