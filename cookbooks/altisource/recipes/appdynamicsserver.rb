#
# Cookbook Name:: altisource
# Recipe:: appdynamicsserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

node.default.volumes = "sdb|opt|opt/appdynamics|defaults"
include_recipe "altisource::volgrp"

package "libaio" do
  action :upgrade
end

group "appdynamics" do
  gid 1001
end

user "appdynamics" do
  comment "Appdynamics User"
  uid  "1001"
  gid  "appdynamics"
  home "/opt/appdynamics"
  shell "/bin/bash"
end

group "appdynamics" do
  gid 1001
  members ["appdynamics"]
end

directory "/opt/appdynamics" do
  owner "appdynamics"
  group "appdynamics"
end

node.default.volumes = "sdb|ad|opt/appdynamics"
include_recipe "altisource::volgrp"

execute "install_check" do
  user "root"
  cwd  "/usr/local/sbin"
  command "/usr/local/sbin/appdyn-setup.sh"
  action :nothing
end

execute "server_check" do
  user "root"
  cwd  "/usr/local/sbin"
  command "/usr/local/sbin/appdyn-server-setup.sh"
  action :nothing
end

template "/usr/local/sbin/appdyn-server-setup.sh" do
  source "appdyn-server-setup.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, resources(:execute => "server_check")
end

template "/usr/local/sbin/appdyn-setup.sh" do
  source "appdyn-setup.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, resources(:execute => "install_check")
end

yumserver = search(:node, "recipes:infrastructure\\:\\:yumserver OR recipes:github\\:\\:yum-repo")
if yumserver.nil? || yumserver.empty?
  Chef::Log.warn("No yumservers found to download controller software.")
else
  yumserver = yumserver.first
  yumserver = yumserver["ipaddress"]
  execute "addown" do
    user "root"
    cwd  "/tmp"
    command "wget -O /tmp/controller_64bit_linux.sh http://#{yumserver}/yum/common/controller_64bit_linux.sh; cd /tmp; chmod +x controller_64bit_linux.sh"
    creates "/tmp/controller_64bit_linux.sh"
    action :run
    not_if "test -f /opt/appdynamics/bin/controller.sh"
    Chef::Log.info("Controller software has been downloaded to the /tmp directory, it still needs to be manually installed.")
  end
end

template "/tmp/response.varfile" do
  source "appdyn-response.varfile.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  Chef::Log.info("To install, issue the following command /tmp/controller_64bit_linux.sh -q -varfile /tmp/response.varfile ")
end

template "/etc/cron.daily/appdynamics" do
  source "appdynamics.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/appdynamics" do
  source "appdynamics-init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

execute "app-init" do
  user  "root"
  command "chkconfig --add appdynamics"
  creates "/etc/rc3.d/S90appdynamics"
  action :run
end

appdynamics = data_bag_item("infrastructure", "appdynamics")
template "/opt/appdynamics/license.lic" do
  source "license.lic.erb"
  owner  "appdynamics"
  group "appdynamics"
  mode  "0644"
  variables(
    :license => appdynamics["license"]
  )
end

