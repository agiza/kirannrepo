#
# Cookbook Name:: rf-iam-app
# Recipe:: default
#
# Copyright 2014, Altisource Labs 
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"
include_recipe "tomcat-all"

yum_package "iam-idp" do 
   action :install
   version "#{node['iam-idp']['rpm']['version']}"
   allow_downgrade true
end

template "/var/chef/cache/shibboleth-identity-provider-2.4.0/src/installer/resources/install.properties" do
    source "install.properties.erb"
    owner "tomcat"
    group "tomcat"
    mode  0775
end

execute "shibboleth-idp install" do
   command 'cd /var/chef/cache/shibboleth-identity-provider-2.4.0; ./install.sh'
   not_if { File.exists?("#{node['shibboleth-idp']['idp_home']}")}
end

execute "shibboleth-idp install" do
   command 'cd /var/chef/cache/shibboleth-identity-provider-2.4.0; ./reinstall.sh'
   only_if { File.exists?("#{node['shibboleth-idp']['idp_home']}") }
end


template "#{node['tomcat']['home']}/bin/setenv.sh" do
     source "setenv.sh.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
end

cookbook_file "/opt/tomcat/lib/mysql-connector-java-5.1.21.jar" do
   source "mysql-connector-java-5.1.21.jar"
    mode  0644
    owner "tomcat"
    group "tomcat"
end

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

directory "#{node['tomcat']['home']}/endorsed" do
   mode 00775
   owner "tomcat"
   group "tomcat"
end

execute "Endorsed Jars" do
  command "cp /var/chef/cache/shibboleth-identity-provider-2.4.0/endorsed/* #{node['tomcat']['home']}/endorsed/"
end

execute "Change protection on endorsed Jars" do
   command "chmod -R 775  #{node['tomcat']['home']}/endorsed;chown -R tomcat:tomcat  #{node['tomcat']['home']}/endorsed"
end

execute "Adjust Ownership" do
  command "chown -R tomcat #{node['shibboleth-idp']['idp_home']};chmod -R 744 #{node['shibboleth-idp']['idp_home']}"
end

yum_package "iam-iamsvc" do
   action :install
   version "#{node['iam-iamsvc']['rpm']['version']}"
   allow_downgrade true
end

file "/etc/init.d/altitomcat" do
   action :delete
end

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

#See if keys and metadata are needed in this environment
result = search(:node, "rf_iam_sp_certpem:* AND chef_environment:#{node.chef_environment}").first
if result.nil?

#copy metadata to idpmetadatafile attribute
Chef::Log.info "Reading data from #{node['rf_idp_metadatafile']}"
ruby_block "add metadata file to node attributes" do
  block do
    f = File.open(node['rf_idp_metadatafile'],"r")
    result = f.read
    node.default[:rf_idp_metadata] = result
  end
end

  #Generate SP metadata file
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
  end

  Chef::Log.info "Reading data from #{node['shibboleth-idp']['idp_home']}/credentials/sp-key.pem}"
  ruby_block "adding key file to node attributes" do
    block do
      f = File.open("#{node['shibboleth-idp']['idp_home']}/credentials/sp-key.pem","r")
      result = f.read
      node.default[:rf_iam_sp_keypem] = result
    end
  end

  Chef::Log.info "Reading data from #{node['rf_idp_metadatafile']}"
  ruby_block "add metadata file to node attributes" do
    block do
      f = File.open(node['rf_sp_metadatafile'],"r")
      result = f.read
      node.default[:rf_sp_metadata] = result
    end
  end

else
 Chef::Log.info "Key and cert found at #{result}, not generationg another one"
end  

