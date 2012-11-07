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

yum_package "mod-pagespeed" do
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

template "/etc/httpd/conf.d/pagespeed.conf" do
  source "pagespeed.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "httpd")
end

# Look up ssl server name from data bag.
servername = data_bag_item("infrastructure", "apache")
template "/etc/httpd/conf.d/ssl.conf" do
  source "ssl.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( 
    :servername => "#{servername['servername'].split(",")[0]}",
    :proxyname => "#{servername['servername'].split(",")[1]}",
    :serveradmin => "#{servername['serveradmin']}"
  )
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/mod_security.conf" do
  source "mod_security.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables( :bodylimit => servername['bodylimit'])
  notifies :reload, resources(:service => "httpd")
end

# Checks to see if there is a servername to correspond with SSL certificates.
if servername['servername'].nil? || servername['servername'].empty?
  Chef::Log.info("No services returned from search.")
else
  servercert = "#{servername['servername'].split(",")[0]}.crt"
  template "/etc/pki/tls/certs/#{servername['servername'].split(",")[0]}.crt" do
    source "servername.crt.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    variables(
      :servercert => servercert,
      :servername => servername
    )
    notifies :reload, resources(:service => "httpd")
  end

  serverkey = "#{servername['servername'].split(",")[0]}.key"
  template "/etc/pki/tls/private/#{servername['servername'].split(",")[0]}.key" do
    source "servername.key.erb"
    owner  "root"
    group  "root"
    mode   "0640"
    variables(
      :serverkey => serverkey,
      :servername => servername
    )
    notifies :reload, resources(:service => "httpd")
  end
end

# Provides a mechanism to include optional configurations by adding them to a data bag item.
sitesinclude = data_bag_item("infrastructure", "apache")
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

