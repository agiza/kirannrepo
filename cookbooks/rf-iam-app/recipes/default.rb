#
# Cookbook Name:: rf-iam-app
# Recipe:: default
#
# Copyright 2014, Altisource Labs 
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"
include_recipe "tomcat"

yum_package "iam-idp" do 
   action :install
   version "#{node['iam']['rpm']['version']}"
   allow_downgrade true
end

template "/var/chef/cache/shibboleth-identity-provider-2.4.3/src/installer/resources/install.properties" do
    source "install.properties.erb"
    owner "tomcat"
    group "tomcat"
    mode  0775
end

execute "shibboleth-idp install" do
   command 'cd /var/chef/cache/shibboleth-identity-provider-2.4.3; ./install.sh'
   not_if { File.exists?("#{node['shibboleth-idp']['idp_home']}")}
end

template "#{node['tomcat']['home']}/bin/setenv.sh" do
     source "setenv.sh.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
end

# Copy MySQL Connector J jar file to Tomcat lib directory
mysql_connector_j "#{node['tomcat']['home']/lib}"

template "#{node['tomcat']['home']}/conf/iamsvc.properties" do
     source "iamsvc.properties.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
end

template "#{node['tomcat']['home']}/conf/realsearch-client.properties" do
     source "realsearch-client.properties.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
    notifies :create, "template[#{node['tomcat']['home']}/conf/server.xml]", :delayed
    notifies :create, "template[#{node['tomcat']['home']}/conf/context.xml]", :delayed
end

template "#{node['tomcat']['home']}/conf/server.xml" do
     source "server.xml.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
     action :nothing
end

template "#{node['tomcat']['home']}/conf/context.xml" do
     source "context.xml.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
     action :nothing
end

template "#{node['tomcat']['home']}/conf/Catalina/localhost/idp.xml" do
  source "idp.xml.erb"
     owner "tomcat"
     group "tomcat"
     mode  00644
end


template "#{node['shibboleth-idp']['idp_home']}/conf/attribute-filter.xml" do 
         source "attribute-filter.xml.erb"
         owner "tomcat"
	 group "tomcat"
         mode 00644
end

template "#{node['shibboleth-idp']['idp_home']}/conf/attribute-resolver.xml" do
         source "attribute-resolver.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end

template "#{node['shibboleth-idp']['idp_home']}/conf/relying-party.xml" do
         source "relying-party.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end
 
template "#{node['shibboleth-idp']['idp_home']}/conf/login.config" do
         source "login.config.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end


template "#{node['shibboleth-idp']['idp_home']}/conf/handler.xml" do
         source "handler.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode 00644
end

execute "Adjust Ownership" do
  command "chown -R tomcat #{node['shibboleth-idp']['idp_home']};chmod -R 744 #{node['shibboleth-idp']['idp_home']}"
end

yum_package "iam-iamsvc" do
   action :install
   version "#{node['iam']['rpm']['version']}"
   allow_downgrade true
end

#file "/etc/init.d/altitomcat" do
#   action :delete
#end

#catalina.sh is lookig for Java in wrong place.  Stupid workaround.

directory "/usr/java/default/bin" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

link "/usr/java/default/bin/java" do
  to "/usr/bin/java"
end

# create iam-sp-metadata.xml if necessary
include_recipe "rf-shib-sp-metagen"

# copy iam-sp-metadata.xml
file "/opt/shibboleth-idp/metadata/iam-sp-metadata.xml" do
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  content IO.read("/iam/share/#{node['chef_environment']}/iam-sp-metadata.xml")
  action :create_if_missing
end

# share idp-metadata.xml if this is the first one, then update local idp-metadata.xml
file "/iam/share/#{node['chef_environment']}/idp-metadata.xml" do
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  content IO.read("/opt/shibboleth-idp/metadata/idp-metadata.xml")
  action :create_if_missing
end

file "/opt/shibboleth-idp/metadata/idp-metadata.xml" do
  action :delete
end

file "/opt/shibboleth-idp/metadata/idp-metadata.xml" do
  content IO.read("/iam/share/#{node['chef_environment']}/idp-metadata.xml")
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  action :create
end

# share idp.key if this is the first one, then update local idp.key
file "/iam/share/#{node['chef_environment']}/iam/idp.key" do
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  content IO.read("/opt/shibboleth-idp/credentials/idp.key")
  action :create_if_missing
end

file "/opt/shibboleth-idp/credentials/idp.key" do
  action :delete
end

file "/opt/shibboleth-idp/credentials/idp.key" do
  content IO.read("/iam/share/#{node['chef_environment']}/iam/idp.key")
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  action :create
end

# share idp.crt if this is the first one, then update local idp.crt
file "/iam/share/#{node['chef_environment']}/iam/idp.crt" do
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  content IO.read("/opt/shibboleth-idp/credentials/idp.crt")
  action :create_if_missing
end

file "/opt/shibboleth-idp/credentials/idp.crt" do
  action :delete
end

file "/opt/shibboleth-idp/credentials/idp.crt" do
  content IO.read("/iam/share/#{node['chef_environment']}/iam/idp.crt")
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  action :create
end

# share idp.jks if this is the first one, then update local idp.jks
file "/iam/share/#{node['chef_environment']}/iam/idp.jks" do
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  content IO.read("/opt/shibboleth-idp/credentials/idp.jks")
  action :create_if_missing
end

file "/opt/shibboleth-idp/credentials/idp.jks" do
  action :delete
end

file "/opt/shibboleth-idp/credentials/idp.jks" do
  content IO.read("/iam/share/#{node['chef_environment']}/iam/idp.jks")
  owner 'tomcat'
  group 'tomcat'
  mode 0755
  action :create
end