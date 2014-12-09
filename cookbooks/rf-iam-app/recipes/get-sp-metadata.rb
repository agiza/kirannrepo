#
# Cookbook Name:: rf-iam-app
# Recipe:: getspmetadata
#
# Copyright 2014, Altisource Labs
#
# All rights reserved - Do Not Redistribute
#
#

execute "Add SP metadata to Shibboleth IDP" do
   command "cd #{node['shibboleth-idp']['idp_home']}/metadata; wget --no-check-certificate https://#{node['rf_webproxy_host']}/Shibboleth.sso/Metadata; mv Metadata sp-metadata.xml"
end

file "#{node['rf_sp_metadatafile']}" do
  owner "tomcat"
  group "tomcat"
  mode 00644
end

service "tomcat" do
  action :stop
end

service "tomcat" do
  action :start
end

