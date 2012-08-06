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

service "httpd" do
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

directory "/var/www/html/demo" do
  owner  "root"
  group  "root"
end

directory "/var/www/html/qa" do
  owner  "root"
  group  "root"
end

directory "/var/www/html/dev" do
  owner  "root"
  group  "root"
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

template "/etc/httpd/conf.d/ssl.conf" do
  source "ssl.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/proxy.d/rtsslproxy.conf" do
  source "rtsslproxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/proxy.d/rtdevproxy.conf" do
  source "rtdevproxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/proxy.d/rtqaproxy.conf" do
  source "rtqaproxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/proxy.d/rtdemoproxy.conf" do
  source "rtdemoproxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/demo-vhost.conf" do
  source "demo-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/twiz-vhost.conf" do
  source "twiz-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end


template "/etc/httpd/conf.d/qa-vhost.conf" do
  source "qa-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/dev-vhost.conf" do
  source "dev-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/datavision-demo.conf" do
  source "datavision-demo.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/datavision-qa.conf" do
  source "datavision-qa.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/corelogic-qa.conf" do
  source "corelogic-qa.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/corelogic-demo.conf" do
  source "corelogic-demo.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/corelogic-dev.conf" do
  source "corelogic-dev.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/httpd/conf.d/vpn.conf" do
  source "vpn.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/pki/tls/certs/altisource.twiz.li.crt" do
  source "altisource.twiz.li.crt.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "httpd")
end

template "/etc/pki/tls/private/altisource.twiz.li.key" do
  source "altisource.twiz.li.key.erb"
  owner  "root"
  group  "root"
  mode   "0640"
  notifies :reload, resources(:service => "httpd")
end

link "/etc/ssl/private" do
  to "/etc/pki/tls/private"
  owner "root"
  group "root"
end

["Dev", "Intdev", "QA", "Demo"].each do |environ|
  vhostNames = search(:node, "role:realtrans-cen AND chef_environment:#{environ}")
  vhostNames = vhostNames.collect { |vhostName| "#{vhostName}" }.join(" ")
  vhostNames = vhostNames.gsub!("node[","")
  vhostNames = vhostNames.gsub!("]","")
  vhostNames = vhostNames.gsub!(".#{node[:domain]}","")
  template "/etc/httpd/proxy.d/realtrans-cen-#{environ}.proxy.conf" do
    source "realtrans-cen.proxy.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    #notifies :reload, resources(:service => "httpd")
    variables(:vhostWorkers => vhostNames)
  end

  template "/etc/httpd/proxy.d/realtrans-ven-#{environ}.proxy.conf" do
    source "realtrans-ven.proxy.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    #notifies :reload, resources(:service => "httpd")
    variables(:vhostWorkers => vhostNames)
  end
 
  template "/etc/httpd/conf.d/#{environ}.vhost.conf" do
    source "vhost.conf.erb"
    owner  "root"
    group  "root"
    mode   "0644"
    #notifies :reload, resources(:service => "httpd")
  end
end



