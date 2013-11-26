#
## Cookbook Name:: infrastructure
## Recipe:: stash
##
## Copyright 2013, Altisource
##
## All rights reserved - Do Not Redistribute
##
## JSM: modeling for stash system
##  
app_name = "stash"
#
#
#
node.set[:java][:oracle][:accept_oracle_download_terms] = true
node.set[:java][:jdk_version]='7'
include_recipe "java::oracle"

package "git" do
  action :upgrade
end

#include_recipe "mysql::server"
#include_recipe "mysql::client"
#
#  As of 11/26/2013 the current stash source was available at:
#  http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-2.9.3.tar.gz
#
src_filename = "atlassian-stash-2.9.3.tar.gz"
src_file = "http://www.atlassian.com/software/stash/downloads/binary/#{src_filename}"
install_path = "/opt/atlassian-stash"

bash 'mkdir_stash' do
  code <<-EOH
    mkdir -p #{install_path}
  EOH
end

remote_file "#{install_path}/#{src_filename}" do
  source  "#{src_file}"
  owner 'root'
  group 'root'
  mode 00644
end

bash 'extract_stash' do
  code <<-EOH
    cd #{install_path}
    tar xzf #{src_filename} 
    EOH
end

