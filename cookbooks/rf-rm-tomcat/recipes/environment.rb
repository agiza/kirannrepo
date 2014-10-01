#
# Cookbook Name:: rf-rm-tomcat
# Recipe:: environment
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/opt/tomcat/bin/setenv.sh" do
     source "setenv.sh.erb"
     owner "tomcat"
     group "tomcat"
     mode    0775
end

template "/opt/tomcat/conf/server.xml" do
    source "server.xml.erb"
end

template "/opt/tomcat/conf/rf-rules-mgmt.properties" do
    source "rf-rules-mgmt.properties.erb"
end

service "tomcat" do 
  action :restart
end
