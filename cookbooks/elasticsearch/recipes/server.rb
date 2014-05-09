#
# Cookbook Name:: elasticsearch
# Recipe:: server
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

package "elasticsearch" do
  action :upgrade
end

file "/etc/profile.d/elasticsearch.sh" do
     owner "root"
     group "root"
     mode  "0644"
     content "export ES_HOME=/usr/share/elasticsearch"
     action :create
end

execute "mapper-attachments plugin" do
  command '/usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/2.0.0'
  not_if do 
     File.exists?("/usr/share/elasticsearch/plugins/mapper-attachments")
  end
end

execute "river-mongodb plugin" do
  command '/usr/share/elasticsearch/bin/plugin -install com.github.richardwilly98.elasticsearch/elasticsearch-river-mongodb/2.0.0'
   not_if do 
     File.exists?("/usr/share/elasticsearch/plugins/river-mongodb")
   end
end

execute "elasticsearch-gui plugin" do
  command '/usr/share/elasticsearch/bin/plugin -install jettro/elasticsearch-gui'
   not_if do
       File.exists?("/usr/share/elasticsearch/plugins/gui")
   end
end

service "elasticsearch" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner  "elasticsearch"
  group  "elasticsearch"
  notifies :restart, resources(:service => "elasticsearch")
end

template "/etc/sysconfig/sysconfig-elasticsearch" do
  source "sysconfig-elasticsearch.erb"
  owner  "root"
  group  "root"
  notifies :restart, resources(:service => "elasticsearch")
end

service "elasticsearch" do
  action [:enable, :start]
end

