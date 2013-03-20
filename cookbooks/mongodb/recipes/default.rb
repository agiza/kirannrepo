#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altirepo"
include_recipe "iptables::default"

service "mongod" do
  supports :stop => true, :start => true, :restart => true, :status => true, :reload => true, :disable => true
  action :nothing
end

%w{mongo-10gen mongo-10gen-server}.each do |package|
  package "#{package}" do
    action :upgrade
    notifies :stop, resources(:service => "mongod")
    notifies :disable, resources(:service => "mongod")
  end
end

%w{/mongod /data /var/run/mongo /data/db}.each do |dir|
  directory "#{dir}" do
    owner  "mongod"
    group  "mongod"
  end
end

link "/data" do
  to "/mongod"
  owner "mongod"
  group "mongod"
end

