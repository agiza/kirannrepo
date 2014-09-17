#
# Cookbook Name:: rf-rm-environment
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

cookbook_file "/tmp/setup_environment.sh" do
   source "setup_environment.sh"
   mode 00755
end

execute "Environment set-up script" do
   command '/tmp/setup_environment.sh'
end

template "/opt/tomcat/conf/rf-rules-mgmt.properties" do
    source "rf-rules-mgmt.properties.erb"
end


service "tomcat" do 
  action :restart
end
