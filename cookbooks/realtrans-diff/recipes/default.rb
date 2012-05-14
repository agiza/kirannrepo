#
# Cookbook Name:: realtrans-diff
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/home/ubuntu/bin/diff_properties.sh" do
  source "diff_properties.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

directory "/home/ubuntu/work" do
  owner "ubuntu"
  group "ubuntu"
end

directory "/home/ubuntu/config" do
  owner "ubuntu"
  group "ubuntu"
end

directory "/home/ubuntu/bin" do
  owner "ubuntu"
  group "ubuntu"
end

execute "diff" do
  command "/home/ubuntu/bin/diff_properties.sh"
  action :nothing
end

template "/home/ubuntu/config/realtrans-central.config" do
  source "realtrans-central.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-rp.config" do
  source "realtrans-rp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-fp.config" do
  source "realtrans-fp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-corelogic.config" do
  source "int-corelogic.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-datavision.config" do
  source "int-datavision.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-etrac.config" do
  source "int-etrac.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-interthinx.config" do
  source "int-interthinx.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-rs.config" do
  source "int-rs.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-rres.config" do
  source "int-rres.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end
