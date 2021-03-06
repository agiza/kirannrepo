#
# Cookbook Name:: atlassian
# Recipe:: nexus
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "iptables::default"
iptables_rule "port_artifactory"
iptables_rule "port_httpd"

package "haproxy" do
  action :upgrade
end

service "haproxy" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
end

cloud_mount "storage" do
  device "/dev/xvdm"
  mountpoint "/storage"
  fstype "ext4"
  options "defaults"
end

cloud_mount "backups" do
  device "/dev/xvdn"
  mountpoint "/backups"
  fstype "ext4"
  options "defaults"
end

%w{/storage/artifactory/etc/opt/jfrog/artifactory /storage/artifactory/opt/jfrog/artifactory /storage/artifactory/var/opt/jfrog/artifactory}.each do |dir|
  directory "#{dir}" do
    action :create
    recursive true
  end
end

link "/etc/opt" do
  to "/storage/artifactory/etc/opt"
end

link "/var/opt/jfrog" do
  to "/storage/artifactory/var/opt/jfrog"
end

link "/opt/jfrog" do
  to "/storage/artifactory/opt/jfrog"
end

package "artifactory" do
  action :upgrade
end

#template "/etc/init.d/artifactory" do
#  source "artifactory-init.erb"
#  owner  "root"
#  group  "root"
#  mode   "0755"
#end

#template "/etc/artifactory/default" do
#  source "artifactory-default.erb"
#  owner  "artifactory"
#  group  "root"
#  mode   "0755"
#end

#template "/etc/artifactory/jetty.xml" do
#  source "artifactory-jetty.xml.erb"
#  owner  "artifactory"
#  group  "root"
#  mode   "0755"
#end

artifactory = []
search(:node, 'recipes:*\\:\\:artifactory') do |n|
  artifactory << n['ipaddress']
end
artifactory = artifactory.first
template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables(
    :server => "#{artifactory}",
    :port => "8081"
  )
  notifies :restart, resources(:service => "haproxy")
end

service "haproxy" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :start
end

service "artifactory" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
end

cron "backups" do
  minute "0"
  user   "root"
  command "rsync -av --delete /storage/ /backups/"
end

cron "config_back" do
  minute "5"
  user   "root"
  command "rsync -av --delete /etc/artifactory /backups/etc/"
end

