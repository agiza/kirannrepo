#wq
# Cookbook Name:: realtrans-config
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

exec "diff" do
  command "/home/ubuntu/bin/diff_properties.sh"
  action :nothing
end

template "/home/ubuntu/bin/diff_properties.sh" do
  source "diff_properties.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

template "/home/ubuntu/config/realtrans-central.config" do
  source "realtrans-central.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/realtrans-rp.config" do
  source "realtrans-rp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/realtrans-fp.config" do
  source "realtrans-fp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/int-corelogic.config"
  source "int-corelogic.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/int-datavision.config"
  source "int-datavision.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/int-etrac.config"
  source "int-etrac.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/int-interthinx.config"
  source "int-interthinx.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/int-rs.config"
  source "int-rs.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end

template "/home/ubuntu/config/int-rres.config"
  source "int-rres.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:command => "diff")
end
