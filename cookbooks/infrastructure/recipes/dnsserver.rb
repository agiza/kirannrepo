#
# Cookbook Name:: infrastructure
# Recipe:: dnsserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "iptables::default"
iptables_rule "port_dns"

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

begin
  zones = data_bag_item("infrastructure", "dns")
    rescue Net::HTTPServerException
      raise "Problem trying to obtain dns information from infrastructure data bag."
end
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

altidev = search(:node, "name:*")
altidev.sort_by!{|x|[x.name]}

rabbitnodes = []
%w{rabbitmqserver rabbitmaster rabbitworker}.each do |app|
  search(:node, "recipes:*\\:\\:#{app} AND chef_environment:shared") do |rabbit|
    rabbitnodes << rabbit["ipaddress"]
  end
end
rabbitnodes = rabbitnodes.sort.uniq
template "/etc/named/altidev.com.db" do
  source "altidev.com.db.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :altidev => altidev,
    :altidevex => zones['altidev.com.db'].split("\\"),
    :cname => zones['altidev_cname'].split("\\"),
    :dnsmaster => zones['dnsmaster'],
    :dnsslaves => zones['dnsslaves'].split("\\"),
    :rabbitproxy => rabbitnodes
  )
end

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

rev0010 = search(:node, "ipaddress:10.0.0*")
rev0010.sort_by!{|x|[x.name]}
template "/etc/named/rev.0.0.10.in-addr.arpa" do
  source "rev.0.0.10.in-addr.arpa.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev0010 => rev0010,
    :rev0010ex => zones['rev.0.0.10'].split("\\")
  )
end

rev1010 = search(:node, "ipaddress:10.0.1*")
rev1010.sort_by!{|x|[x.name]}
template "/etc/named/rev.1.0.10.in-addr.arpa" do
  source "rev.1.0.10.in-addr.arpa.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev1010 => rev1010,
    :rev1010ex => zones['rev.1.0.10'].split("\\")
  )
end

rev2010 = search(:node, "ipaddress:10.0.2*")
rev2010.sort_by!{|x|[x.name]}
template "/etc/named/rev.2.0.10.in-addr.arpa" do
  source "rev.2.0.10.in-addr.arpa.erb"
  owner  "named"
  group  "named"
  mode   "0644"
  notifies :reload, resources(:service => "named")
  variables(
    :serial => zones['serial'],
    :rev2010 => rev2010
  )
end

service "named" do
  action [:enable, :start]
end

