#
# Cookbook Name:: atlas-server
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/etc/init.d/confluence" do
  source "confluence-start.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/crowd" do
  source "crowd-start.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/fisheye" do
  source "fisheye-start.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/jira" do
  source "jira-start.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

service "confluence" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end

service "jira" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end

service "fisheye" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end

service "crowd" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action [:enable, :start]
end

service "apache2" do
  supports :start => true, :stop => true, :restart => true, :status => true, :reload => true
  action :enable
end

template "/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties" do
  source "confluence-init.properties.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, resources(:service => "confluence")
end

template "/opt/atlassian/confluence/conf/server.xml" do
  source "confluence-server.xml.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :restart, resources(:service => "confluence")
end

template "/opt/atlassian/jira/atlassian-jira/WEB-INF/classes/jira-application.properties" do
  source "jira-application.properties.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "jira")
end

template "/opt/atlassian/jira/conf/server.xml" do
  source "jira-server.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "jira")
end

template "/opt/atlassian/fisheye/bin/fisheyectl.sh" do
  source "fisheyectl.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
  notifies :restart, resources(:service => "fisheye")
end

template "/opt/atlassian/crowd/crowd.cfg.xml" do
  source "crowd.cfg.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "crowd")
end

template "/opt/atlassian/crowd/crowd-openidserver-webapp/WEB-INF/classes/crowd.properties" do
  source "crowd.properties.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "crowd")
end

template "/opt/atlassian/cli/user-add.sh" do
  source "user-add.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/opt/atlassian/cli/user-remove.sh" do
  source "user-remove.sh.erb"
  owner "root"
  group "root"
  mode  "0755"
end

template "/etc/init.d/confluence" do
  source "confluence.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/jira" do
  source "jira.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/init.d/fisheye" do
  source "fisheye.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/cron.daily/atlassian-backup" do
  source "atlassian-backup.erb"
  owner "root"
  group "root"
  mode  "0755"
end

template "/etc/cron.daily/confluence" do
  source "confluence-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "/etc/cron.daily/jira" do
  source "jira-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "/etc/cron.daily/fisheye" do
  source "fisheye-cron.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "/etc/apache2/sites-available/conf-mod_proxy" do
  source "conf-mod_proxy.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/sites-enabled/conf-mod_proxy" do
  to "../sites-available/conf-mod_proxy"
  owner "root"
  group "root"
end

template "/etc/apache2/sites-available/jira-mod_proxy" do
  source "jira-mod_proxy.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/sites-enabled/jira-mod_proxy" do
  to "../sites-available/jira-mod_proxy"
  owner "root"
  group "root"
end

template "/etc/apache2/sites-available/fisheye-mod_proxy" do
  source "fisheye-mod_proxy.erb"
  owner "root"
  group "root"
  mode  "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/sites-enabled/fisheye-mod_proxy" do
  to "../sites-available/fisheye-mod_proxy"
  owner "root"
  group "root"
end

template "/etc/apache2/sites-available/bamboo-mod_proxy" do
  source "bamboo-mod_proxy.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/sites-enabled/bamboo-mod_proxy" do
  to "../sites-available/bamboo-mod_proxy"
  owner "root"
  group "root"
end

template "/etc/apache2/sites-available/nexus-mod_proxy" do
  source "nexus-mod_proxy.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/sites-enabled/nexus-mod_proxy" do
  to "../sites-available/nexus-mod_proxy"
  owner "root"
  group "root"
end

template "/opt/atlassian/cli/atlassian.sh" do
  source "atlassian.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/etc/apache2/sites-available/vpn-mod_proxy" do
  source "vpn-mod_proxy.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/sites-enabled/vpn-mod_proxy" do
  to "../sites-available/vpn-mod_proxy"
  owner "root"
  group "root"
end

template "/etc/apache2/sites-available/realtrans-dev-mod_proxy" do
  source "realtrans-dev-mod_proxy.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "apache2")
end

link  "/etc/apache2/sites-enabled/realtrans-dev-mod_proxy" do
  to "../sites-available/realtrans-dev-mod_proxy"
  owner "root"
  group "root"
end

template "/etc/apache2/sites-available/crowd-mod_proxy" do
  source "crowd-mod_proxy.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :reload, resources(:service => "apache2")
end

link  "/etc/apache2/sites-enabled/crowd-mod_proxy" do
  to "../sites-available/crowd-mod_proxy"
  owner "root"
  group "root"
end

template "/etc/ssl/certs/altisource.twiz.li.crt" do
  source "altisource.twiz.li.crt.erb"
  owner  "root"
  group  "root"
  mode   "644"
end

template "/etc/ssl/private/altisource.twiz.li.key" do
  source "altisource.twiz.li.key.erb"
  owner  "root"
  group  "root"
  mode   "0640"
end

template "/etc/apache2/sites-available/appdyn-mod_proxy" do
  source "appdyn-mod_proxy.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "/etc/apache2/sites-available/default" do
  source "default.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "/etc/apache2/sites-available/default-ssl" do
  source "default-ssl.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "/etc/apache2/sites-available/prototype-vhost.conf" do
  source "prototype-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "/etc/apache2/sites-available/ux-vhost.conf" do
  source "ux-vhost.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "/etc/apache2/sites-available/yum-mod_proxy" do
  source "yum-mod_proxy.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

link  "/etc/apache2/sites-enabled/000-default" do
  to "../sites-available/default"
  owner "root"
  group "root"
end

link  "/etc/apache2/sites-enabled/000-default-ssl" do
  to "../sites-available/default-ssl"
  owner "root"
  group "root"
end

link  "/etc/apache2/sites-enabled/appdyn-mod_proxy" do
  to "../sites-available/appdyn-mod_proxy"
  owner "root"
  group "root"
end

link  "/etc/apache2/sites-enabled/prototype-vhost.conf" do
  to "../sites-available/prototype-vhost.conf"
  owner "root"
  group "root"
end

link  "/etc/apache2/sites-enabled/ux-vhost.conf" do
  to "../sites-available/ux-vhost.conf"
  owner "root"
  group "root"
end

link  "/etc/apache2/sites-enabled/yum-mod_proxy" do
  to "../sites-available/yum-mod_proxy"
  owner "root"
  group "root"
end

