#
# Cookbook Name:: infrastructure
# Recipe:: dnsserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
package "bind" do
  case node[:platform]
  when "ubuntu"
    package_name "bind9"
  when "centos", "redhat"
    package_name "bind"
  end
  action :upgrade
end

package "bind-utils" do
  case node[:platform]
  when "centos", "redhat"
    package_name "bind-utils"
  when "ubuntu"
    package_name "bind9-utils"
  end
  action :upgrade
end

directory "/etc/named" do
  owner "root"
  group "named"
end

service "named" do
case node[:platform]
when "centos", "redhat"
  service_name "named"
when "ubuntu"
  service_name "bind9"
end
supports :stop => true, :start => true, :restart => true, :reload => true
action :nothing
end

zones = data_bag_item("dns", "zones")
template "/etc/named.conf" do
  source "named.conf.server.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/named/named.conf.options" do
  source "named.conf.options.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/named/named.conf.local" do
  source "named.conf.local.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :restart, resources(:service => "named")
  variables( :dnsslaves => zones['dnsslaves'].split("\\") )
end

template "/etc/named/named.conf.default-zones" do
  source "named.conf.default-zones.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/rndc.key" do
  source "rndc.key.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/named/altidev.com.db" do
  source "altidev.com.db.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :altidev => zones['altidev.com.db'].split("\\"),
    :cname => zones['altidev_cname'].split("\\"),
    :dnsmaster => zones['dnsmaster'],
    :dnsslaves => zones['dnsslaves'].split("\\")
  )
end

#hosts = search(:node, "*:*")
#template "/etc/named/altidev.com.db.new" do
#  source "altidev.com.db.new.erb"
#  owner  "named"
#  group  "named"
#  mode   "0644"
#  notifies :reload, resources(:service => "named")
#  variables(
#    :serial => zones['serial'],
#    :altidev => hosts,
#    :cname => zones['CNAME'].split("\\"),
#    :dnsmaster => zones['dnsmaster'],
#    :dnsslaves => zones['dnsslaves'].split("\\")
#  )
#end

template "/etc/named/ascorp.com.db" do
  source "ascorp.com.db.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :ascorp => zones['ascorp.com.db'].split("\\"),
    :dnsmaster => zones['dnsmaster'],
    :dnsslaves => zones['dnsslaves'].split("\\")
  )
end

template "/etc/named/rev.0.0.10.in-addr.arpa" do
  source "rev.0.0.10.in-addr.arpa.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev0010 => zones['rev.0.0.10'].split("\\")
  )
end

template "/etc/named/rev.1.0.10.in-addr.arpa" do
  source "rev.1.0.10.in-addr.arpa.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev1010 => zones['rev.1.0.10'].split("\\")
  )
end

template "/etc/named/rev.2.0.10.in-addr.arpa" do
  source "rev.2.0.10.in-addr.arpa.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev2010 => zones['rev.2.0.10'].split("\\")
  )
end

#template "/etc/defaults/bind9" do
#  source "bind9.erb"
#  owner  "root"
#  group  "root"
#  mode   "0644"
#  notifies :restart, resources(:service => "named")
#end

service "named" do
  action [:enable, :start]
end

