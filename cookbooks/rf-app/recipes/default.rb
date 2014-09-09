#
# Cookbook Name:: rf-app
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#

include_recipe "java"
include_recipe "tomcat-all"

yum_package "iam-idp" do 
   action :upgrade
end

execute "shibboleth-idp install" do
    command 'cd /var/chef/cache/shibboleth-identity-provider-2.4.0; ./install.sh'
end

template "/opt/tomcat/bin/setenv.sh" do
     source "setenv.sh.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
end

template "/opt/tomcat/conf/Catalina/localhost/idp.xml" do
  source "idp.xml.erb"
     owner "tomcat"
     group "tomcat"
     mode  00644
end


template "/opt/shibboleth-idp/conf/attribute-filter.xml" do 
         source "attribute-filter.xml.erb"
         owner "tomcat"
	 group "tomcat"
         mode 00644
end

template "/opt/shibboleth-idp/conf/attribute-resolver.xml" do
         source "attribute-resolver.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end

template "/opt/shibboleth-idp/conf/relying-party.xml" do
         source "relying-party.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end
 
template "/opt/shibboleth-idp/conf/login.config" do
         source "login.config.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end


template "/opt/shibboleth-idp/conf/handler.xml" do
         source "handler.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end

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
         mode 00644
end

service "httpd" do
   action :restart
end

include_recipe "shibboleth-sp" 

template "/etc/shibboleth/attribute-map.xml" do
   source "attribute-map.xml.erb"
    owner "root"
    group "root"
    mode 00644
end
 
template "/etc/shibboleth/attribute-policy.xml" do
   source "attribute-policy.xml.erb"
    owner "root"
    group "root"
    mode 00644
end

execute "Copy idp-metadata file" do 
   command 'cp /opt/shibboleth-idp/metadata/idp-metadata.xml /etc/shibboleth'
end


template "/etc/shibboleth/shibboleth2.xml" do
   source "shibboleth2.xml.erb"
    owner "root"
    group "root"
    mode 00644
end

template "/etc/shibboleth/localLogout.html" do
   source "localLogout.html.erb"
    owner "root"
    group "root"
    mode 00644
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

directory "/var/www/html/iam" do
   owner "root"
   group "root"
   mode  00775
end


cookbook_file "/var/www/html/iam/index.html" do
  source "index.html"
  mode "0775"
end

service "shibd" do
  action :restart
end

service "httpd" do 
  action :restart
end

execute "Add SP metadata to Shibboleth IDP" do
   command 'cd /opt/shibboleth-idp/metadata;wget --no-check-certificate https://rfint-iam-app1.altidev.net/Shibboleth.sso/Metadata;mv Metadata sp-metadata.xml'
end

directory "/opt/tomcat/endorsed" do
   mode 00775 
   owner "tomcat"
   group "tomcat"
end

execute "Endorsed Jars" do
  command 'cp /var/chef/cache/shibboleth-identity-provider-2.4.0/endorsed/* /opt/tomcat/endorsed/'
end

execute "Change protection on endorsed Jars" do
   command 'chmod -R 775 /opt/tomcat/endorsed;chown -R tomcat:tomcat /opt/tomcat/endorsed'
end

execute "Adjust Ownership" do
  command 'chown -R tomcat /opt/shibboleth-idp;chmod -R 744 /opt/shibboleth-idp'
end

yum_package "iam-iam" do 
    action :upgrade
end

yum_package "iam-iamsvc" do
    action :upgrade
end


yum_package "iam-selfsvc" do
    action :upgrade
end

#yum_package "iam-home" do
#    action :upgrade
#end

service "shibd" do
  action :restart
end

service "httpd" do
  action :restart
end

file "/etc/init.d/altitomcat" do
   action :delete
end

include_recipe "iptables::disabled"

service "tomcat" do
  action :stop
end

service "tomcat" do 
  action :start
end
