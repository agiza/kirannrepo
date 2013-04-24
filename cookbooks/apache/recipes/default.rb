#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
include_recipe "iptables::default"
iptables_rule "port_http"

# Install packages
%w{httpd mod_ssl}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

# Include epel repository for optional packages
include_recipe "altisource::epel-local"

# Optional package recipes
include_recipe "apache::mod_security"
include_recipe "apache::mod_bw"
include_recipe "apache::mod_limitipconn"

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action :nothing
end

execute "test-apache-config" do
  command "apachectl configtest"
  action :nothing
  notifies :reload, resources(:service => "httpd"), :delayed
end

%w{/var/www/html/vpn /etc/httpd/proxy.d}.each do |dir|
  directory "#{dir}" do
    owner  "root"
    group  "root"
    recursive true
  end
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "test-apache-config"), :delayed
end

# Look up ssl server name from data bag.
apachedata = data_bag_item("infrastructure", "apache")
if apachedata['securesite'].nil? || apachedata['securesite'].empty?
  Chef::Log.info("No SSL sites returned from search, SSL configuration will be skipped.")
else
  # Sets up the ssl config file using servername for ssl.conf and proxyname is second element which is the proxy that is included in the ssl configuration by default.  Note, wildcards supported so you can include multiple sites.
  ssldata = apachedata['securesite']
  servername = ssldata['servername'].split(",")[0]
  proxyname = ssldata['servername'].split(",")[1]
  template "/etc/httpd/conf.d/ssl.conf" do
    source "ssl.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    variables( 
      :servername => "#{servername}",
      :proxyname => "#{proxyname}",
      :serveradmin => "#{ssldata['serveradmin']}"
    )
    notifies :run, resources(:execute => "test-apache-config"), :delayed
  end
  # Uses servername to grab for the data element that contains the certificate.
  servercert = ssldata["sslcert"]
  template "/etc/pki/tls/certs/#{servername}.crt" do
    source "servername.crt.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    variables(
      :servercert => servercert,
      :servername => "#{servername}"
    )
    notifies :run, resources(:execute => "test-apache-config"), :delayed
  end
  # This grabs private key to populate the server private key.
  serverkey = ssldata["sslkey"]
  template "/etc/pki/tls/private/#{servername}.key" do
    source "servername.key.erb"
    owner  "root"
    group  "root"
    mode   "0640"
    variables(
      :serverkey => serverkey,
      :servername => "#{servername}"
    )
    notifies :run, resources(:execute => "test-apache-config"), :delayed
  end
end

# Provides a mechanism to include optional configurations by adding them to a data bag item, separated by pipe character.
# For each site included, there must be a matching config file template.
if apachedata['serversites'].nil? || apachedata['serversites'].empty?
  Chef::Log.info("No Optional configuration entries returned from search.")
else
  serveripallow = apachedata['serveripallow']
  sitesinclude = apachedata['serversites'].split("|")
  sitesinclude.each do |site|
    template "/etc/httpd/conf.d/#{site}.conf" do
      source "#{site}.conf.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      variables(
        :serveripallow => serveripallow
      )
      notifies :run, resources(:execute => "test-apache-config"), :delayed
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

include_recipe "apache::rtvhost"
include_recipe "apache::rdvhost"
include_recipe "apache::l1vhost"
include_recipe "apache::rfvhost"

