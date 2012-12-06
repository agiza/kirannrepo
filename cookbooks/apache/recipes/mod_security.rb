#
# Cookbook Name:: apache
# Recipe:: mod_security
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "mod_security" do
  action :upgrade
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

apachedata = data_bag_item("infrastructure", "apache")
template "/etc/httpd/conf.d/mod_security.conf" do
  source "mod_security.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :bodylimit => apachedata['bodylimit'])
  notifies :reload, resources(:service => "httpd")
end

