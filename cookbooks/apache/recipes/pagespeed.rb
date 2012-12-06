#
# Cookbook Name:: apache
# Recipe:: pagespeed
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "mod-pagespeed" do
  action :upgrade
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/httpd/conf.d/pagespeed.conf" do
  source "pagespeed.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "httpd")
end

