#
# Cookbook Name:: bamboo-server
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

service "bamboo" do
  supports :stop => true, :start => true, :restart => true, :statue => true
  action [:enable, :start]
end

directory "/home/bamboo/.ssh" do
  owner "bamboo"
  group "bamboo"
  action :create
end

directory "/home/bamboo/bin" do
  owner "bamboo"
  group "bamboo"
  action :create
end

bamboo_keys = data_bag_item("atlassian_keys", "bamboo")

template "/opt/atlassian/bamboo/bamboo.cfg.xml" do
  source "bamboo.cfg.xml.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

template "/opt/atlassian/bamboo/bamboo.cfg.xml.new" do
  source "bamboo.cfg.xml.new.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  variables(
    :bamboo_key => bamboo_keys['bamboo_key']
  )
end

template "/opt/atlassian/bamboo/bamboo-mail.cfg.xml" do
  source "bamboo-mail.cfg.xml.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

template "/etc/init.d/bamboo" do
  source "bamboo.erb"
  owner  "root"
  group  "root"
  mode   "0755"
  notifies :restart, resources(:service => "bamboo")
end

template "/opt/atlassian/bamboo/webapp/WEB-INF/classes/bamboo-init.properties" do
  source "bamboo-init.properties.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

template "/etc/cron.hourly/data-bak.sh" do
  source "data-bak.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

template "/opt/atlassian/bamboo/conf/wrapper.conf" do
  source "wrapper.conf.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  notifies :restart, resources(:service => "bamboo")
end

link "/opt/atlassian/bamboo/artifacts" do
  to "/mnt/bamboo_data/artifacts"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/rpmbuild" do
  to "/mnt/bamboo_data/rpmbuild"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/.m2" do
  to "/mnt/bamboo_data/.m2"
  owner "bamboo"
  group "bamboo"
end

link "/home/bamboo/.m2" do
  to "/mnt/bamboo_data/.m2"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/plugins" do
  to "/mnt/bamboo_data/plugins"
  owner "bamboo"
  group "bamboo"
end

template "/home/bamboo/bin/bamboo-git-tag" do
  source "bamboo-git-tag.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0755"
end

template "/home/bamboo/bin/chef-run.sh" do
  source "chef-run.sh.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0755"
end

template "/home/bamboo/bin/tomcat-command-rhel.sh" do
  source "tomcat-command-rhel.sh.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0755"
end

template "/home/bamboo/bin/tomcat-command.sh" do
  source "tomcat-command.sh.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
end

template "/home/bamboo/bin/tomcat-clean.sh" do
  source "tomcat-clean.sh.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
end

template "/home/bamboo/bin/tomcat-clean-rhel.sh" do
  source "tomcat-clean-rhel.sh.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
end

template "/home/bamboo/bin/rpm-package" do
  source "rpm-package.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
end

link "/usr/lib/apache-maven-2.2.1" do
  to "/opt/apache-maven-2.2.1"
  owner "root"
  group "root"
end

link "/usr/lib/apache-maven-3.0.4" do
  to "/opt/apache-maven-3.0.4"
  owner "root"
  group "root"
end

link "/usr/lib/jdk1.6.0_25" do
  to "/opt/jdk1.6.0_25"
  owner "root"
  group "root"
end

link "/usr/lib/jdk1.7.0_03" do
  to "/opt/jdk1.7.0_03"
  owner "root"
  group "root"
end

link "/usr/lib/jvm/jdk1.6.0_25" do
  to "/usr/lib/jdk1.6.0_25"
  owner "root"
  group "root"
end

link "/usr/lib/jvm/jdk1.7.0_03" do
  to "/usr/lib/jdk1.7.0_03"
  owner "root"
  group "root"
end

template "/usr/lib/apache-maven-2.2.1/conf/settings.xml" do
  source "settings.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "/usr/lib/apache-maven-3.0.4/conf/settings.xml" do
  source "settings.xml.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

link "/home/bamboo/.chef" do
  to "/opt/bamboo/.chef"
  owner "bamboo"
  group "bamboo"
end

template "/home/bamboo/.chef/client.rb" do
  source "client.rb.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0644"
end

template "/home/bamboo/.chef/knife.rb" do
  source "knife.rb.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0664"
end

template "/home/bamboo/.chef/validation.pem" do
  source "validation.pem.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0644"
end

template "/home/bamboo/.chef/client.pem" do
  source "client.pem.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0600"
end

template "/home/bamboo/.chef/bamboo.altidev.com.pem" do
  source "bamboo.altidev.com.pem.erb"
  owner "bamboo"
  group "bamboo"
  mode  "0600"
end

