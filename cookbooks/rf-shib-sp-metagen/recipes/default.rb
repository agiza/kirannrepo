#
# Cookbook Name:: rf-shib-sp-metagen
# Recipe:: default
#
# Copyright 2014, Altisource Labs 
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "#{node['shibboleth-idp']['idp_home']}/bin/keygen.sh" do
 source "keygen.sh"
  mode  0775
  owner "tomcat"
  group "tomcat"
end

cookbook_file "#{node['shibboleth-idp']['idp_home']}/bin/metagen.sh" do
 source "metagen.sh"
  mode  0775
  owner "tomcat"
  group "tomcat"
end

execute "Generate key" do
command "#{node['shibboleth-idp']['idp_home']}/bin/keygen.sh  -f -u shibd -h #{node['rf_webproxy_host']} -y 3 -e https://#{node['rf_webproxy_host']} -o #{node['shibboleth-idp']['idp_home']}/credentials"
end

execute "Generate SP metadata" do
command "#{node['shibboleth-idp']['idp_home']}/bin/metagen.sh -2ALN -c #{node['shibboleth-idp']['idp_home']}/credentials/sp-cert.pem -e https://#{node['rf_webproxy_host']}/shibboleth -h #{node['rf_webproxy_host']} > #{node['shibboleth-idp']['idp_home']}/metadata/sp-metadata.xml"
end

file "#{node['shibboleth-idp']['idp_home']}/metadata/sp-metadata.xml" do
  mode  0660
  owner "tomcat"
  group "tomcat"
end

#copy key and cert to node attribute
Chef::Log.info "Reading data from #{node['shibboleth-idp']['idp_home']}/credentials/sp-cert.pem}"
ruby_block "adding cert file to node attributes" do
block do
  f = File.open("#{node['shibboleth-idp']['idp_home']}/credentials/sp-cert.pem","r")
  result = f.read
  node.default[:rf_iam_sp_certpem] = result
end
