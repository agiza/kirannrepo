#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

yum_package "httpd" do
  action :upgrade
end

yum_package "mod_security" do
  action :upgrade
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

directory "/var/www/html/demo" do
  owner  "root"
  group  "root"
end

directory "/var/www/html/qa" do
  owner  "root"
  group  "root"
end

directory "/var/www/html/dev" do
  owner  "root"
  group  "root"
end

directory "/var/www/html/vpn" do
  owner  "root"
  group  "root"
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/rtdevproxy.conf" do
  source "rtdevproxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/rtqaproxy.conf" do
  source "rtqaproxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/rtdemoproxy.conf" do
  source "rtdemoproxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/demo-vhost.conf"
  source "demo-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/qa-vhost.conf"
  source "qa-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/dev-vhost.conf"
  source "dev-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/datavision-demo.conf" do
  source "datavison-demo.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/httpd/conf.d/datavision-qa.conf" do
  source "datavison-qa.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/httpd/conf.d/corelogic-qa.conf" do
  source "corelogic-qa.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/httpd/conf.d/corelogic-demo.conf" do
  source "corelogic-demo.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/httpd/conf.d/corelogic-dev.conf" do
  source "corelogic-dev.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/httpd/conf.d/vpn.conf" do
  source "vpn.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "httpd")
end

