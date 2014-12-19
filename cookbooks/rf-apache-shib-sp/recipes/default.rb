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

include_recipe "shibboleth-sp"

include_recipe "rf-shib-sp-metagen"

template "/etc/httpd/conf/httpd.conf" do
         source "httpd.conf.erb"
         owner "root"
         group "root"
         mode '0755'
end

directory "/etc/httpd/ssl" do
   owner "root"
   group "root"
   mode  '0775'
   action :create
end

execute "copy rf.crt" do
  command "cp /iam/share/ssl/rf.crt /etc/httpd/ssl"
  only_if do
    File.exists?("/iam/share/ssl/rf.crt")
  end
end

execute "copy rf.key" do
  command "cp /iam/share/ssl/rf.key /etc/httpd/ssl"
  only_if do
    File.exists?("/iam/share/ssl/rf.key")
  end
end

template "/etc/httpd/conf.d/ssl.conf" do
   source "ssl.conf.erb"
     owner "root"
     group "root"
     mode  '0775'
end

template "/etc/shibboleth/attribute-map.xml" do
   source "attribute-map.xml.erb"
    owner "root"
    group "root"
    mode '0755'
end

template "/etc/shibboleth/attribute-policy.xml" do
   source "attribute-policy.xml.erb"
    owner "root"
    group "root"
    mode '0755'
end

template "/etc/shibboleth/shibboleth2.xml" do
   source "shibboleth2.xml.erb"
    owner "root"
    group "root"
    mode '0755'
end

template "/etc/shibboleth/localLogout.html" do
   source "localLogout.html.erb"
    owner "root"
    group "root"
    mode '0755'
end


execute "copy sp-cert.pem" do
  command "cp -f /iam/share/#{node.chef_environment}/#{node['sp_app_name']}/sp-cert.pem /etc/shibboleth/sp-cert.pem"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/#{node['sp_app_name']}/sp-cert.pem")
  end
end

execute "copy sp-key.pem" do
  command "cp -f /iam/share/#{node.chef_environment}/#{node['sp_app_name']}/sp-key.pem /etc/shibboleth/sp-key.pem"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/#{node['sp_app_name']}/sp-key.pem")
  end
end

execute "copy idp-metadata.xml" do
  command "cp /iam/share/#{node.chef_environment}/idp-metadata.xml /etc/shibboleth"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/idp-metadata.xml")
  end
end