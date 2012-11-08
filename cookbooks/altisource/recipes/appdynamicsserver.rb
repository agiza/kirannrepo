#
# Cookbook Name:: altisource
# Recipe:: appdynamicsserver
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

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

execute "install_check" do
  user "root"
  cwd  "/usr/local/sbin"
  command "/usr/local/sbin/appdyn-setup.sh"
  action :nothing
end

template "/usr/local/sbin/appdyn-setup.sh" do
  source "appdyn-setup.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, resources(:execute => "install_check")
end

execute "addown" do
  user "root"
  cwd  "/tmp"
  command "wget -O /tmp/controller_64bit_linux.sh http://10.0.0.20/yum/common/controller_64bit_linux.sh; cd /tmp; chmod +x controller_64bit_linux.sh"
  creates "/opt/appdynamics/bin/controller.sh"
  action :run
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
    :appdyn_expireDate => appdynamics["appdyn_expireDate"],
    :appdyn_macaddress => appdynamics["appdyn_macaddress"],
    :appdyn_signature => appdynamics["appdyn_signature"], 
    :appdyn_startDate => appdynamics["appdyn_startDate"],
    :appdyn_custName => appdynamics["appdyn_custName"],
    :appdyn_createDate => appdynamics["appdyn_createDate"],
    :appdyn_agents => appdynamics["appdyn_agents"],
    :appdyn_email => appdynamics["appdyn_email"]
  )
end

