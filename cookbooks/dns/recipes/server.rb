#
# Cookbook Name:: dns
# Recipe:: server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
yum_package "bind" do
  action :upgrade
end

yum_package "bind-utils" do
  action :upgrade
end

service "named" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

zones = data_bag_item("dns" "zones")
template "/etc/named.conf" do
  source "named.conf.server.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/named/named.conf.options" do
  source "named.conf.options.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/named/named.conf.local" do
  source "named.conf.local.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
  variables( :dnsslaves => zones['dnsslaves'] )
end

template "/etc/named/named.conf.default-zones" do
  source "named.conf.default-zones.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/rndc.key" do
  source "rndc.key.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "named")
end

template "/etc/named/altidev.com.db" do
  source "altidev.com.db"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :altidev => zones['altidev.com.db'].split("\n")
  )
end

template "/etc/named/ascorp.com.db" do
  source "ascorp.com.db"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :ascorp => zones['ascorp.com.db'].split("\n")
  )
end

template "/etc/named/rev.0.0.10.in-addr.arpa.erb" do
  source "rev.0.0.10.in-addr.arpa"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev0010 => zones['rev.0.0.10'].split("\n")
  )
end

template "/etc/named/rev.1.0.10.in-addr.arpa.erb" do
  source "rev.1.0.10.in-addr.arpa"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev1010 => zones['rev.1.0.10'].split("\n")
  )
end

template "/etc/named/rev.2.0.10.in-addr.arpa.erb" do
  source "rev.2.0.10.in-addr.arpa"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev2010 => zones['rev.2.0.10'].split("\n")
  )
end

service "named" do
  action [:enable, :start]
end

