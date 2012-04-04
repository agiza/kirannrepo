#
# Cookbook Name:: altitomcat
# Recipe:: default
#

#include_recipe "java"

tomcat_pkgs = value_for_platform(
  ["centos","redhat","fedora"] => {
    "default" => ["altitomcat-1.0.0-4.noarch"]
  },
  "default" => ["altitomcat-1.0.0-4.noarch"]
)
tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "/etc/sysconfig/real_region" do
  source "real_region.erb"
  group 'root'
  owner 'root'
  mode '0644'
  #notifies :restart, resources(:service => "tomcat")
end

template "/opt/tomcat/bin/catalina.sh" do
  source "catalina_sh.erb"
  group "tomcat"
  owner "tomcat"
  mode "0755"
end

