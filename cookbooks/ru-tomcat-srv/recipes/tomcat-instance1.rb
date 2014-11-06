#
# Cookbook Name:: ru-tomcat-srv
# Recipe:: tomcat-instance1 
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'tomcat::default'

node.override["tomcat"]["base_version"] = 7
node.override["tomcat"]["run_base_instance"] = false
node.override["tomcat"]["java_options"] = '-Xms2G -Xmx2G -Djava.awt.headless=true'


tomcat_instance "ruqa1" do 
 port 8080
 shutdown_port 8005
end

#name "tomcat-instance1"
#run_list("recipe[tomcat]")
#override_attributes(
#  'tomcat' => {
#    'java_options' => "${JAVA_OPTS} -Xmx128M -Djava.awt.headless=true",
#    'base_version' => "7",
#    'port' => "8080",
#    'shutdown_port' => "8005",
#    'instances' => "instance1",
#    'run_base_instance' => "false"
#  }
#)

