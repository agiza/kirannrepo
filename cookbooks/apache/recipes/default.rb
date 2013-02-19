#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

%w[httpd mod_ssl].each do |pkg|
  package pkg do
    action :upgrade
  end
end

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
  subscribes :reload, resources(:service => "httpd"), :delayed
end

%w[/var/www/html/vpn /etc/httpd/proxy.d].each do |dir|
  directory dir do
    owner  "root"
    group  "root"
  end
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  #notifies :reload, resources(:service => "httpd")
  subscribes :run, resources(:execute => "test-apache-config"), :delayed
end

# Look up ssl server name from data bag.
apachedata = data_bag_item("infrastructure", "apache")
if apachedata['servername'].nil? || apachedata['servername'].empty?
  Chef::Log.info("No services returned from search.")
else
  # Sets up the ssl config file using servername for ssl.conf and proxyname is second element which is the proxy that is included in the ssl configuration by default.  Note, wildcards supported so you can include multiple sites.
  servername = "#{apachedata['servername'].split(",")[0]}"
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
    #notifies :reload, resources(:service => "httpd")
    subscribes :run, resources(:execute => "test-apache-config"), :delayed
  end
  # Uses servername to grab for the data element that contains the certificate.
  servercert = apachedata["sslcert"]
  template "/etc/pki/tls/certs/#{servername}.crt" do
    source "servername.crt.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    variables(
      :servercert => servercert,
      :servername => "#{servername}"
    )
    #notifies :reload, resources(:service => "httpd")
    subscribes :run, resources(:execute => "test-apache-config"), :delayed
  end
  # This grabs private key to populate the server private key.
  serverkey = apachedata["sslkey"]
  template "/etc/pki/tls/private/#{servername}.key" do
    source "servername.key.erb"
    owner  "root"
    group  "root"
    mode   "0640"
    variables(
      :serverkey => serverkey,
      :servername => "#{servername}"
    )
    #notifies :reload, resources(:service => "httpd")
    subscribes :run, resources(:execute => "test-apache-config"), :delayed
  end
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
      variables(
        :serveripallow => apachedata['serveripallow'].split("|")
      )
      #notifies :reload, resources(:service => "httpd")
      subscribes :run, resources(:execute => "test-apache-config"), :delayed
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

