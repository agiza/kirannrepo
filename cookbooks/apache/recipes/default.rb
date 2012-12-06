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
apachedata = data_bag_item("infrastructure", "apache")
if apachedata['servername'].nil? || apachedata['servername'].empty?
  Chef::Log.info("No services returned from search.")
else
  # Sets up the ssl config file using servername for ssl.conf and proxyname is second element which is the proxy that is included in the ssl configuration by default.  Note, wildcards supported so you can include multiple sites.
  template "/etc/httpd/conf.d/ssl.conf" do
    source "ssl.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    variables( 
      :servername => "#{apachedata['servername'].split(",")[0]}",
      :proxyname => "#{apachedata['servername'].split(",")[1]}",
      :serveradmin => "#{apachedata['serveradmin']}"
    )
    notifies :reload, resources(:service => "httpd")
  end
  # Uses servername to grab for the data element that contains the certificate.
  servercert = "#{apachedata['servername'].split(",")[0]}.crt"
  template "/etc/pki/tls/certs/#{apachedata['servername'].split(",")[0]}.crt" do
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
  # This grabs private key to populate the server private key.
  serverkey = "#{apachedata['servername'].split(",")[0]}.key"
  template "/etc/pki/tls/private/#{apachedata['servername'].split(",")[0]}.key" do
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

# Config file for mod_security.
template "/etc/httpd/conf.d/mod_security.conf" do
  source "mod_security.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables( :bodylimit => apachedata['bodylimit'])
  notifies :reload, resources(:service => "httpd")
end

# Provides a mechanism to include optional configurations by adding them to a data bag item, separated by pipe character.
# For each site included, there must be a matching config file template.
if apachedata['serversites'].nil? || apachedata['serversites'].empty?
  Chef::Log.info("No services returned from search.")
else
  sitesinclude = apachedata['serversites'].split("|")
  sitesinclude.each do |site|
    template "/etc/httpd/conf.d/#{site}.conf" do
      source "#{site}.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      notifies :reload, resources(:service => "httpd")
    end
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

