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
src_filepath = "http://www.atlassian.com/software/stash/downloads/binary/#{src_filename}"
extract_path = "/opt/atlassian-stash"

remote_file "#{extract_path}/#{src_filename}" do
  source  "#{src_filepath}"
  owner 'root'
  group 'root'
  mode 00644
  not_if { ::File.exists?(extract_path) }
end

bash 'extract_stash' do
  cwd ::File.dirname(extract_path)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{src_filename} -C #{extract_path}
    mv #{extract_path}/*/* #{extract_path}/
    EOH
  not_if { ::File.exists?(extract_path) }
end

