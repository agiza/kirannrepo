#
# Cookbook Name:: infrastructure
# Recipe:: admin
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/root/bin/vpn-client.sh" do
  source "vpn-client.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/root/bin/vpn-revoke.sh" do
  source "vpn-revoke.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/home/ubuntu/bin/vpn-client.sh" do
  source "vpn-client.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/bin/vpn-revoke.sh" do
  source "vpn-revoke.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/bin/client-key.sh" do
  source "client-key.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/bin/client-revoke.sh" do
  source "client-revoke.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/bin/openvpn-client.sh" do
  source "openvpn-client.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/bin/openvpn-revoke.sh" do
  source "openvpn-revoke.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/bin/openvpn-resend.sh" do
  source "openvpn-resend.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

rhel_hosts = search(:node, "platform:redhat OR platform:centos").collect { |host| "#{host}"}.join(" ").gsub!("\[", "").gsub!("\, \{\}\]","").uniq.split(" ")
ubuntu_hosts = search(:node, "platform:ubuntu").collect { |host| "#{host}"}.join(" ").gsub!("\[", "").gsub!("\, \{\}\]","").uniq.split(" ")

template "/home/ubuntu/bin/rhel_host" do
  source "rhel_host.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0644"
  variables(:rhel_hosts => rhel_hosts)
end

template "/home/ubuntu/bin/ubuntu_host" do
  source "ubuntu_host.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0644"
  variables(:ubuntu_hosts => ubuntu_hosts)
end

template "/home/ubuntu/bin/update.sh" do
  source "update.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/bin/drop-files" do
  source "drop-files.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end
