#
# Cookbook Name:: rf_iam_liquibase
# Recipe:: default
#
# Copyright 2014, Altisource Labs
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"
include_recipe "liquibase-cookbook-master"

mysql_connector_j "#{node[:liquibase][:install_path]}"

cookbook_file "#{node[:liquibase][:install_path]}/iam.changelog.xml" do
  source "iam.changelog.xml"
  mode  00775
  owner "root"
  group "root"
end

cookbook_file "#{node[:liquibase][:install_path]}/iam_large_entity.sql" do
  source "iam_large_entity.sql"
  mode  00775
  owner "root"
  group "root"
end

cookbook_file "#{node[:liquibase][:install_path]}/initData.sql" do
  source "initData.sql"
  mode  00775
  owner "root"
  group "root"
end

cookbook_file "#{node[:liquibase][:install_path]}/master-db-changelog.xml" do
  source "master-db-changelog.xml"
  mode  00775
  owner "root"
  group "root"
end

service "mysqld" do
  action :start
end

bash 'Execute Liquibase through command line' do
  cwd "#{node[:liquibase][:install_path]}"
  code <<-EOH
  java -jar "#{node[:liquibase][:install_path]}/liquibase.jar" \
      --driver="#{node[:rf_iam_liquibase][:connection][:driver]}" \
      --classpath="#{node[:liquibase][:install_path]}/mysql-connector-java-#{node['mysql_connector']['j']['version']}-bin.jar" \
      --changeLogFile="#{node[:liquibase][:install_path]}/#{node[:rf_iam_liquibase][:change_log_file]}" \
      --url="jdbc:#{node[:rf_iam_liquibase][:connection][:adapter]}://#{node[:ipaddress]}:#{node[:rf_iam_liquibase][:connection][:port]}/#{node[:rf_iam_liquibase][:connection][:database]}?useJvmCharsetConverters=true" \
      --username=#{node[:rf_iam_liquibase][:connection][:username]} \
      --password=#{node[:rf_iam_liquibase][:connection][:password]} \
      update
  EOH
end

# TODO: Figure out why migrate is not working from community cookbook.
# variables from config_templates_variables are also injected
# connection_variables = {
#     host: 'iam-web-test-node',
#     url: "jdbc:mysql://#{node[:ipaddress]}:3306/real_usermgt",
#     port: 3306,
#     database: 'real_usermgt',
#     username: 'rfng_iam_user',
#     password: 'awd37jk'
# }

# liquibase_cookbook_master_migrate name do
#   change_log_file "master-db-changelog.xml"
#   jar "#{node[:liquibase][:install_path]}/liquibase.jar"
#
#   connection(connection_variables)
#
#   classpath "#{node[:liquibase][:install_path]}"
#   cwd "#{node[:liquibase][:install_path]}"
#
#   action :run
#
# end