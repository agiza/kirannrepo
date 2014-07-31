#
# Cookbook Name:: atlassian
# Recipe:: crowd
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

#template "/etc/init.d/crowd" do
#  source "crowd-init.erb"
#  owner  "root"
#  group  "root"
#  mode   "0755"
#end

#service "crowd" do
#  supports :start => true, :stop => true, :restart => true, :status => true
#  action :nothing
#end

#template "/opt/atlassian/crowd/crowd.cfg.xml" do
#  source "crowd.cfg.xml.erb"
#  owner  "root"
#  group  "root"
#  mode   "0644"
#  notifies :restart, resources(:service => "crowd")
#end

#template "/opt/atlassian/crowd/crowd-openidserver-webapp/WEB-INF/classes/crowd.properties" do
#  source "crowd.properties.erb"
#  owner  "root"
#  group  "root"
#  mode   "0644"
#  notifies :restart, resources(:service => "crowd")
#end
#
#
#execute "mysql_connector" do
#  command "echo 'Installing mysql-connector-java-#{node[:mysql_connector_version]}-bin.jar'"
#  not_if { ::File.exists?("/opt/atlassian/crowd/apache-tomcat/lib/mysql-connector-java-#{node[:mysql_connector_version]}-bin.jar")} 
#end

perl "remove_previous_mysql_connector" do
  cwd "/opt/atlassian/crowd/apache-tomcat/lib/"
  code <<-EOH
     my $directory = '.';
     print "Latest: mysql-connector-java-#{node[:mysql_connector_version]}-bin.jar\n";
     opendir (DIR, $directory) or die $!;
     while (my $file = readdir(DIR)) {
        if ($file =~ /mysql-connector-java-.+-bin\.jar/)
        {
           if ($file ne "mysql-connector-java-#{node[:mysql_connector_version]}-bin.jar") 
              {print "Removing old library: $file\n";}
              unlink($file);
        }
     }
    closedir (DIR);
    EOH
end

#remote_file "install_latest_mysql_connector_lib" do
#  mysql_connector_lib = "mysql-connector-java-#{node[:mysql_connector_version]}-bin.jar"
#  mysql_connector_path = "/opt/atlassian/crowd/apache-tomcat/lib"
#  path mysql_connector_path+"/"+mysql_connector_lib
#  source "http://#{node[:yumrepo_host]}/yum/common/"+mysql_connector_lib
#  mode  "0644"
#  owner "root"
#  group "root"
#  action :create_if_missing
#  not_if { ::File.exists?(mysql_connector_path+"/"+mysql_connector_lib)}
#end

remote_file "/opt/atlassian/crowd/apache-tomcat/lib/mysql-connector-java-5.1.31-bin.jar" do
   source "http://10.0.0.72/yum/common/mysql-connector-java-5.1.31-bin.jar"
   checksum "2f984e744c20"
   mode "0644"
   owner "root"
   group "root"
   action :create_if_missing
end

#service "crowd" do
#  supports :start => true, :stop => true, :restart => true, :status => true
#  action :start
#end

