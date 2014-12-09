#
# Cookbook Name:: rf-apache-shib-sp
# Recipe:: default
#
# Copyright 2014, Altisource Labs 
#
# All rights reserved - Do Not Redistribute
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
end

cookbook_file "/etc/httpd/ssl/rf.crt" do
  source "rf.crt"
  mode "0775"
end

cookbook_file "/etc/httpd/ssl/rf.key" do
  source "rf.key"
  mode "0775"
end

template "/etc/httpd/conf.d/ssl.conf" do
   source "ssl.conf.erb"
     owner "root"
     group "root"
     mode  0775
end

yum_package "iam-iam" do
    action :install
    version "#{node['iam-iam']['rpm']['version']}"
    allow_downgrade true
end

yum_package "iam-selfsvc" do
    action :install
    version "#{node['iam-selfsvc']['rpm']['version']}"
    allow_downgrade true
end

yum_package "iam-home" do
    action :install
    version "#{node['iam-home']['rpm']['version']}"
    allow_downgrade true
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

#the copy idp-metadata.xml runs at compile time, so the directory has to be created ffrst
directory "#{node['rf_idp_metadatadir']}" do
    owner "root"
    group "root"
    mode 0755
    not_if { File.exist?("#node['rf_sp_metadatadir") }
end

# copy idp-metadata.xml
ruby_block "copy-metadata" do
  block do
    result = search(:node, "name:#{node['rf_idp_servername']}").first
    if result.nil?
      Chef::Log.info "IDP server not found"
    else
        f = File.open(node['rf_idp_metadata'],"w")
        f.write("#{result[:rf_idp_metadata]}")
        f.close
    end
  end
  action :run
end

ruby_block "get key" do
  block do
    result = search(:node, "rf_iam_sp_certpem:* AND chef_environment:#{node.chef_environment}").first
    if result.nil?
      Chef::Log.info "IDP server not found"
    else
        f = File.open(node['rf_iam_sp_key'],"w")
        f.write("#{result[:rf_iam_sp_keypem]}")
        f.close
    end
  end
  action :run
end

ruby_block "get key" do
  block do
    result = search(:node, "rf_iam_sp_certpem:* AND chef_environment:#{node.chef_environment}").first
    if result.nil?
      Chef::Log.info "IDP server not found"
    else
        f = File.open(node['rf_iam_sp_cert'],"w")
        f.write("#{result[:rf_iam_sp_certpem]}")
        f.close
    end
  end
  action :run
end

service "shibd" do
  action :restart
end

service "httpd" do
  action :restart
end

