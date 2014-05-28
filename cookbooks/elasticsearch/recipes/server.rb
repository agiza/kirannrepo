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

directory "/usr/share/elasticsearch/logs" do
        owner "root"
	group "root"
        mode 00755
        action :create
end

template "/etc/profile.d/elasticsearch.sh" do
     source "elasticsearch.sh.erb"
     owner "root"
     group "root"
     mode  00755
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
  mode  00775
  notifies :restart, resources(:service => "elasticsearch")
end

template "/etc/sysconfig/sysconfig-elasticsearch" do
  source "sysconfig-elasticsearch.erb"
  owner  "root"
  group  "root"
  mode  00775
  notifies :restart, resources(:service => "elasticsearch")
end

directory "/usr/share/elasticsearch/indextmp" do
        owner "root"
        group "root"
        mode 00755
        action :create
end

template "/usr/share/elasticsearch/indextmp/aliases.json" do
     source "aliases.json.erb"
     owner "root"
     group "root"
     mode  00755
     action :create
end

template "/usr/share/elasticsearch/indextmp/dispatchesIndex.json" do
     source "dispatchesIndex.json.erb"
     owner "root"
     group "root"
     mode  00755
     action :create
end

template "/usr/share/elasticsearch/indextmp/dispatchesMapping.json" do
     source "dispatchesMapping.json.erb"
     owner "root"
     group "root"
     mode  00755
     action :create
end

template "/usr/share/elasticsearch/indextmp/documentsIndex.json" do
     source "documentsIndex.json.erb"
     owner "root"
     group "root"
     mode  00755
     action :create
end

template "/usr/share/elasticsearch/indextmp/documentsMapping.json" do
     source "documentsMapping.json.erb"
     owner "root"
     group "root"
     mode  00755
     action :create
end

template "/usr/share/elasticsearch/indextmp/dropindex.json" do
     source "dropindex.json.erb"
     owner "root"
     group "root"
     mode  00755
     action :create
end

template "/usr/share/elasticsearch/indextmp/elasticSearchRiverIndex.sh" do
     source "elasticSearchRiverIndex.sh.erb"
     owner "root"
     group "root"
     mode  00755
     action :create
end

service "elasticsearch" do
  action [:enable, :start]
end

print @mongodb_host

execute "elasticSearchRiverIndex" do
  command "/usr/share/elasticsearch/indextmp/elasticSearchRiverIndex.sh -h localhost -p #{elasticsearch_port} -k #{mongodb_host} -q #{mongodb_port} -d #{mongodb_database} -v #{elasticsearch_index}"
  action :run
end

