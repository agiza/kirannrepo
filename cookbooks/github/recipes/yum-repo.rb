#
# Cookbook Name:: github
# Recipe:: yum-repo
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

%w{yum apache2}.each do |package|
  package "#{package}" do
    action :upgrade
  end
end

template "/usr/local/bin/yum-update" do
  source "yum-update.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

cron "yum-update" do
  minute "5"
  user "root"
  command "/usr/local/bin/yum-update"
end

template "/etc/apache2/sites-available/default" do
  source "default.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

link "/etc/apache2/sites-enabled/000-default" do
  to "../sites-available/default"
end

