#
# Cookbook Name:: rf-rm-mongodb
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

include_recipe "mongodb"

cookbook_file "/tmp/realservicing-runtime.tar.gz" do
     source "realservicing-runtime.tar.gz"
     mode 00775
end
 
execute "unzip realservicing-runtime" do 
   command 'cd /tmp;tar -xvf /tmp/realservicing-runtime.tar.gz'
end

package "mongodb-enterprise-mongos" do
  action :install
end

package "mongodb-enterprise-shell" do
  action :install
end
 
package "mongodb-enterprise-tools" do
  action :install
end

execute "mongodbrestore" do 
   command 'sleep 120s;mongorestore --db realservicing-runtime /tmp/realservicing-runtime'
end

service "mongod" do 
   action :restart
end

