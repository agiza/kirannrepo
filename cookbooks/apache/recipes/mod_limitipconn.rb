#
# Cookbook Name:: apache
# Recipe:: mod_limitipconn
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "mod_limitipconn" do
  action :upgrade
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

#template "/etc/httpd/conf.d/mod_limitipconn.conf" do
#  source "mod_limitipconn.conf.erb"
#  owner "root"
#  group "root"
#  mode "0644"
#  notifies :reload, resources(:service => "httpd")
#end

