#
# Cookbook Name:: rf-iam-app
# Recipe:: default
#

include_recipe "java"
include_recipe "tomcat-all"

yum_package "iam-idp" do 
   action :install
   version "#{node['iam']['rpm']['version']}"
   allow_downgrade true
end

template "/var/chef/cache/shibboleth-identityprovider-2.4.3/src/installer/resources/install.properties" do
    source "install.properties.erb"
    owner "tomcat"
    group "tomcat"
    mode  '0775'
end

execute "shibboleth-idp install" do
   command 'cd /var/chef/cache/shibboleth-identityprovider-2.4.3; chmod 755 install.sh; ./install.sh'
end

execute "Adjust Ownership" do
  command "chown -R tomcat #{node['shibboleth-idp']['idp_home']};chmod -R 744 #{node['shibboleth-idp']['idp_home']}"
end

template "#{node['tomcat']['home']}/bin/setenv.sh" do
     source "setenv.sh.erb"
     owner "tomcat"
     group "tomcat"
     mode    '0775'
end

# Copy MySQL Connector J jar file to Tomcat lib directory
mysql_connector_j "#{node['tomcat']['home']}/lib"

template "#{node['tomcat']['home']}/conf/iamsvc.properties" do
     source "iamsvc.properties.erb"
     owner "tomcat"
     group "tomcat"
     mode    '0775'
end

template "#{node['tomcat']['home']}/conf/realsearch-client.properties" do
     source "realsearch-client.properties.erb"
     owner "tomcat"
     group "tomcat"
     mode    '0775'
    notifies :create, "template[#{node['tomcat']['home']}/conf/server.xml]", :delayed
    notifies :create, "template[#{node['tomcat']['home']}/conf/context.xml]", :delayed
end

template "#{node['tomcat']['home']}/conf/server.xml" do
     source "server.xml.erb"
     owner "tomcat"
     group "tomcat"
     mode    '0775'
     action :nothing
end

template "#{node['tomcat']['home']}/conf/context.xml" do
     source "context.xml.erb"
     owner "tomcat"
     group "tomcat"
     mode    '0775'
     action :nothing
end

template "#{node['tomcat']['home']}/conf/Catalina/localhost/idp.xml" do
  source "idp.xml.erb"
     owner "tomcat"
     group "tomcat"
     mode  '0644'
end


template "#{node['shibboleth-idp']['idp_home']}/conf/attribute-filter.xml" do 
     source "attribute-filter.xml.erb"
     owner "tomcat"
	 group "tomcat"
     mode '0644'
end

template "#{node['shibboleth-idp']['idp_home']}/conf/attribute-resolver.xml" do
         source "attribute-resolver.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode '0644'
end

template "#{node['shibboleth-idp']['idp_home']}/conf/relying-party.xml" do
         source "relying-party.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode '0644'
end
 
template "#{node['shibboleth-idp']['idp_home']}/conf/login.config" do
         source "login.config.erb"
         owner "tomcat"
         group "tomcat"
         mode '0644'
end


template "#{node['shibboleth-idp']['idp_home']}/conf/handler.xml" do
         source "handler.xml.erb"
         owner "tomcat"
         group "tomcat"
         mode '0644'
end

execute "Adjust Ownership" do
  command "chown -R tomcat:tomcat #{node['shibboleth-idp']['idp_home']}; chmod -R 744 #{node['shibboleth-idp']['idp_home']}"
end

yum_package "iam-iamsvc" do
   action :install
   version "#{node['iam']['rpm']['version']}"
   allow_downgrade true
end

file "/etc/init.d/altitomcat" do
   action :delete
end

#catalina.sh is looking for Java in wrong place.  Stupid workaround.

directory "/usr/java/default/bin" do
  owner "root"
  group "root"
  mode '0755'
  recursive true
end

link "/usr/java/default/bin/java" do
  to "/usr/bin/java"
end

# create iam-sp-metadata.xml if necessary
include_recipe "rf-shib-sp-metagen"

execute "copy iam-sp-metadata.xml" do
  command "cp /iam/share/#{node.chef_environment}/iam-sp-metadata.xml /opt/shibboleth-idp/metadata"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/iam-sp-metadata.xml")
  end
end

# share idp-metadata.xml, if this is the first idp node
execute "share idp-metadata.xml" do
  command "cp -p /opt/shibboleth-idp/metadata/idp-metadata.xml /iam/share/#{node.chef_environment}"
  not_if do
    File.exists?("/iam/share/#{node.chef_environment}/idp-metadata.xml")
  end
end

# copy the shared idp-metadata.xml
execute "copy idp-metadata.xml" do
  command "cp -fp /iam/share/#{node.chef_environment}/idp-metadata.xml /opt/shibboleth-idp/metadata/idp-metadata.xml"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/idp-metadata.xml")
  end
end

# share idp.key if this is the first one
execute "share idp.key" do
  command "cp -p /opt/shibboleth-idp/credentials/idp.key /iam/share/#{node.chef_environment}/iam/idp.key"
  not_if do
    File.exists?("/iam/share/#{node.chef_environment}/iam/idp.key")
  end
end

#copy the shared idp.key
execute "copy idp.key" do
  command "cp -fp /iam/share/#{node.chef_environment}/iam/idp.key /opt/shibboleth-idp/credentials/idp.key"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/iam/idp.key")
  end
end

# share idp.crt if this is the first one
execute "share idp.crt" do
  command "cp -p /opt/shibboleth-idp/credentials/idp.crt /iam/share/#{node.chef_environment}/iam/idp.crt"
  not_if do
    File.exists?("/iam/share/#{node.chef_environment}/iam/idp.crt")
  end
end

#copy the shared idp.crt
execute "copy idp.crt" do
  command "cp -fp /iam/share/#{node.chef_environment}/iam/idp.crt /opt/shibboleth-idp/credentials/idp.crt"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/iam/idp.crt")
  end
end

# share idp.jks if this is the first one
execute "share idp.jks" do
  command "cp -p /opt/shibboleth-idp/credentials/idp.jks /iam/share/#{node.chef_environment}/iam/idp.jks"
  not_if do
    File.exists?("/iam/share/#{node.chef_environment}/iam/idp.jks")
  end
end

#copy the shared idp.jks
execute "copy idp.jks" do
  command "cp -fp /iam/share/#{node.chef_environment}/iam/idp.jks /opt/shibboleth-idp/credentials/idp.jks"
  only_if do
    File.exists?("/iam/share/#{node.chef_environment}/iam/idp.jks")
  end
end

service 'tomcat' do
  action :restart
end