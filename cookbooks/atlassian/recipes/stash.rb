#
## Cookbook Name:: atlassian
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

#package "git" do
#  action :upgrade
#end
include_recipe "git::source"


#include_recipe "mysql::server"
#include_recipe "mysql::client"
#
#  As of 11/26/2013 the current stash source was available at:
#  http://www.atlassian.com/software/stash/downloads/binary/atlassian-stash-2.9.3.tar.gz
#
src_vers = "atlassian-stash-2.9.3"
src_file = "http://www.atlassian.com/software/stash/downloads/binary/#{src_vers}.tar.gz"
install_path = "/opt/atlassian-stash"
install_file = "#{install_path}/#{src_vers}.tar.gz"
install_vers = "#{install_path}/#{src_vers}"

bash 'mkdir_stash' do
  code <<-EOH
    mkdir -p #{install_path}
    mkdir -p #{install_path}/stash-data
  EOH
  not_if { ::File.exists?(install_path) }
end


remote_file "#{install_file}" do
  source  "#{src_file}"
  owner 'root'
  group 'root'
  mode 00644
  not_if { ::File.exists?(install_file) }
end

bash 'extract_stash' do
  code <<-EOH
    cd #{install_path}
    tar xzf #{src_vers}.tar.gz 
    chown -R root:root #{src_vers}
    EOH
  not_if { ::File.exists?(install_vers) }
end

