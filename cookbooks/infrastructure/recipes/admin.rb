#
# Cookbook Name:: infrastructure
# Recipe:: admin
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

%w{vpn-client vpn-revoke}.each do |template|
  template "/root/bin/#{template}.sh" do
    source "#{template}.sh.erb"
    owner  "root"
    group  "root"
    mode   "0755"
  end
end

%w{vpn-client vpn-revoke client-key client-revoke openvpn-client openvpn-revoke openvpn-resend}.each do |template|
  template "/home/ubuntu/bin/#{template}.sh" do
    source "#{template}.sh.erb"
    owner  "ubuntu"
    group  "ubuntu"
    mode   "0755"
  end
end

rhel_hosts = []
ubuntu_hosts = []
search(:node, "platform:redhat OR platform:centos").each do |host|
  rhel_hosts << host["hostname"]
end
rhel_hosts = rhel_hosts.sort.uniq

search(:node, "platform:ubuntu").each do |host|
  ubuntu_hosts << host["hostname"]
end
ubuntu_hosts = ubuntu_hosts.sort.uniq

template "/home/ubuntu/bin/rhel_host" do
  source "rhel_host.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0644"
  variables(:rhel_host => rhel_host)
end

template "/home/ubuntu/bin/ubuntu_host" do
  source "ubuntu_host.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0644"
  variables(:ubuntu_hosts => ubuntu_hosts)
end

%w{update.sh drop-files}.each do |script|
  template "/home/ubuntu/bin/#{script}" do
    source "#{script}.erb"
    owner  "ubuntu"
    group  "ubuntu"
    mode   "0755"
  end
end

