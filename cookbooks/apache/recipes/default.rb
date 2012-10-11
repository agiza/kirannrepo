#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "epelinstall" do
  command "rpm -Uvh --nosignature http://<%= node[:yum_server] %>/yum/common/epel-release-6-7.noarch.rpm"
  creates "/etc/yum.repos.d/epel.repo"
  action  :run
end

yum_package "httpd" do
  action :upgrade
end

yum_package "mod_security" do
  action :upgrade
end

yum_package "mod_ssl" do
  action :upgrade
end

yum_package "mod_bw" do
  action :upgrade
end

yum_package "mod_limitipconn" do
  action :upgrade
end

yum_package "mod-pagespeed-stable_current" do
  action :upgrade
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

directory "/var/www/html/vpn" do
  owner  "root"
  group  "root"
end

directory "/etc/httpd/proxy.d" do
  owner "root"
  group "root"
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "httpd")
end

# Look up ssl server name from data bag.
servername = data_bag_item("apache-server", "webhost")
servername = servername['servername'].split(",")
bodylimit = data_bag_item("apache-server", "webhost")
bodylimit = bodylimit['bodylimit']
admin = data_bag_item("apache-server", "webhost")
admin = admin['serveradmin']
template "/etc/httpd/conf.d/ssl.conf" do
  source "ssl.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( 
    :servername => "#{servername[0]}",
    :proxyname => "#{servername[1]}",
    :serveradmin => "#{admin}"
  )
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/mod_security.conf" do
  source "mod_security.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables( :bodylimit => bodylimit )
  notifies :reload, resources(:service => "httpd")
end

#template "/etc/httpd/proxy.d/#{servername[0]}.conf" do
#  source "#{servername[0]}.conf.erb"
#  owner  "root"
#  group  "root"
#  mode   "0644"
#  variables( :proxyname => "#{servername[1]}" )
#  notifies :reload, resources(:service => "httpd")
#end

template "/etc/pki/tls/certs/#{servername[0]}.crt" do
  source "#{servername[0]}.crt.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/pki/tls/private/#{servername[0]}.key" do
  source "#{servername[0]}.key.erb"
  owner  "root"
  group  "root"
  mode   "0640"
  notifies :reload, resources(:service => "httpd")
end

#template "/etc/httpd/conf.d/#{servername[0]}-vhost.conf" do
#  source "#{servername[0]}-vhost.conf.erb"
#  owner  "root"
#  group  "root"
#  mode   "0644"
#  variables( 
#    :servername => "#{servername[0]}",
#    :proxyname => "#{servername[1]}"
#  )
#  notifies :reload, resources(:service => "httpd")
#end

sitesinclude = data_bag_item("apache-server", "webhost")
sitesinclude = sitesinclude['serversites'].split("|")
sitesinclude.each do |site|
  template "/etc/httpd/conf.d/#{site}.conf" do
    source "#{site}.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    notifies :reload, resources(:service => "httpd")
  end
end

link "/etc/ssl/private" do
  to "/etc/pki/tls/private"
  owner "root"
  group "root"
end

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

