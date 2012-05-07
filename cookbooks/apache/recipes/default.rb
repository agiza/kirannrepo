#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

package "apache2" do
  package_name "apache2"
  action :upgrade
end

package "mod_security" do
  package_name "mod_security"
  action :upgrade
end

service "apache2" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :enable
  action :start
end

template "/etc/apache2/httpd.conf"
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/ports.conf"
  source "ports.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/apache2.conf"
  source "apache2.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/conf.d/security"
  source "security.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/000-default"
  source "default.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/000-default-ssl"
  source "default-ssl.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/corelogic-dev-mod_proxy"
  source "corelogic-dev-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/corelogic-demo-mod_proxy"
  source "corelogic-demo-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/corelogic-qa-mod_proxy"
  source "corelogic-qa-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/datavision-dev-mod_proxy"
  source "datavison-dev-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/datavision-demo-mod_proxy"
  source "datavison-demo-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/datavision-qa-mod_proxy"
  source "datavison-qa-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/rtqa-mod_proxy"
  source "rtqa-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/vpn-mod_proxy"
  source "vpn-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/mods-enabled/proxy_http.load" do
  to "../mods-available/proxy_http.load"
  only_if "test -f /etc/apache2/mods-available/proxy_http.load"
end

link "/etc/apache2/mods-enabled/proxy.conf" do
  to "../mods-available/proxy.conf"
  only_if "test -f /etc/apache2/mods-available/proxy.conf"
end

link "/etc/apache2/mods-enabled/proxy.load" do
  to "../mods-available/proxy.load"
  only_if "test -f /etc/apache2/mods-available/proxy.load"
end

link "/etc/apache2/mods-enabled/proxy_balancer.load" do
  to "../mods-available/proxy_balancer.load"
  only_if "test -f /etc/apache2/mods-available/proxy_balancer.load"
end

link "/etc/apache2/mods-enabled/proxy_balancer.conf" do
  to "../mods-available/proxy_balancer.conf"
  only_if "test -f /etc/apache2/mods-available/proxy_balancer.conf"
end

link "/etc/apache2/mods-enabled/auth_digest.load" do
  to "../mods-available/auth_digest.load"
  only_if "test -f /etc/apache2/mods-available/auth_digest.load"
end

link "/etc/apache2/mods-enabled/ssl.conf" do
  to "../mods-available/ssl.conf"
  only_if "test -f /etc/apache2/mods-available/ssl.conf"
end

link "/etc/apache2/mods-enabled/ssl.load" do
  to "../mods-available/ssl.load"
  only_if "test -f /etc/apache2/mods-available/ssl.load"
end

link "/etc/apache2/mods-enabled/mod-security.load" do
  to "../mods-available/mod-security.load"
  only_if "test -f /etc/apache2/mods-available/mod-security.load"
end

link "/etc/apache2/mods-enabled/mod-security.conf" do
  to "../mods-available/mod-security.conf"
  only_if "test -f /etc/apache2/mods-available/mod-security.conf"
end

link "/etc/apache2/mods-enabled/unique_id.load" do
  to "../mods-available/unique_id.load"
  only_if "test -f /etc/apache2/mods-available/unique_id.load"
end

