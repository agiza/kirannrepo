#
# Cookbook Name:: rf-apache-shib-sp
# Recipe:: default
#

yum_package "httpd" do
   action :upgrade
end

yum_package "mod_ssl" do
   action :upgrade
end

template "/etc/httpd/conf/httpd.conf" do
         source "httpd.conf.erb"
         owner "root"
         group "root"
         mode 0755
end

directory "/etc/httpd/ssl" do
   owner "root"
   group "root"
   mode  00775
   action :create
end

file "/etc/httpd/ssl/rf.crt" do
  mode '0775'
  content IO.read("/iam/share/ssl/rf.crt")
  action :create_if_missing
end

file "/etc/httpd/ssl/rf.key" do
  mode '0775'
  content IO.read("/iam/share/ssl/rf.key")
  action :create_if_missing
end

template "/etc/httpd/conf.d/ssl.conf" do
   source "ssl.conf.erb"
     owner "root"
     group "root"
     mode  0775
end

include_recipe "shibboleth-sp"

template "/etc/shibboleth/attribute-map.xml" do
   source "attribute-map.xml.erb"
    owner "root"
    group "root"
    mode 0755
end

template "/etc/shibboleth/attribute-policy.xml" do
   source "attribute-policy.xml.erb"
    owner "root"
    group "root"
    mode 0755
end

template "/etc/shibboleth/shibboleth2.xml" do
   source "shibboleth2.xml.erb"
    owner "root"
    group "root"
    mode 0755
end

template "/etc/shibboleth/localLogout.html" do
   source "localLogout.html.erb"
    owner "root"
    group "root"
    mode 0755
end

include_recipe "rf-shib-sp-metagen"

# replace key/cert pair (remove first and then create)

file "/etc/shibboleth/sp-cert.pem" do
  action :delete
end

file "/etc/shibboleth/sp-cert.pem" do
  mode '0644'
  owner 'root'
  group 'root'
  content IO.read("/iam/share/#{node['chef_environment']}/#{node['sp_app_name']}/sp-cert.pem")
  action :create
end

file "/etc/shibboleth/sp-key.pem" do
  action :delete
end

file "/etc/shibboleth/sp-key.pem" do
  mode '0644'
  owner 'root'
  group 'root'
  content IO.read("/iam/share/#{node['chef_environment']}/#{node['sp_app_name']}/sp-key.pem")
  action :create
end

# copy idp-metadata.xml
file "/etc/shibboleth/idp-metadata.xml" do
  owner 'root'
  group 'root'
  mode 0755
  content IO.read("/iam/share/#{node['chef_environment']}/idp-metadata.xml")
  action :create
end

