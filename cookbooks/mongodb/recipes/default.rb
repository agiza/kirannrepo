#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"

package "mongo-10gen" do
  action :upgrade
end

package "mongo-10gen-server" do
  action :upgrade
end

execute "install_check" do
  user  "root"
  cwd   "/usr/local/sbin"
  command "/usr/local/sbin/mongod-setup.sh"
  action :nothing
end

template "/usr/local/sbin/mongod-setup.sh" do
  source "mongod-setup.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :run, resources(:execute => "install_check")
end

template "/usr/local/sbin/replset-setup.py" do
  source "replset-setup.py.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

