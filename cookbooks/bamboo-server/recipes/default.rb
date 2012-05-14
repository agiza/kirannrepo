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
  action :enable
  action :start
end
bambooLicenseKey = 'AAABMA0ODAoPeNptkF1rgzAUhu/zKwK7TjG2lrUQWNUw3NQWbdnNbqI7WwM1ShLL/PdLbbuPMkhu8vC+5zm5K3uFMzFgOnVnSe+XdIGjeIt9j/ooBlNr2VnZKhaKpmpbzJUF3Wlp4HWJ+VEcenHCKO+bCvT6fWdAG+YHKNIwklhYYKc24gWEzlDUKitqm4sGWKgHofBmL5WC4Up4JuSBVSc06c7oQRysNG2va5jUbYN+5jKre0DV6DZxYXmE85MrcaZKqBr4Zyf18MtjTuj0mkllDcoAf5NjHc+3vNgUScnRWn8IJc15zOpbAJU8Z+6SlM7pwgvmqAR9BJ3ELHx8WZHnMvDIbvbkk8QPy5sx26GDcfNonWW8iJJVii7I5dMk/lN8dfvXf+Nk9sLA7f9+AWwPmK8wLAIUVNr6ciLulZ0lzzzqLzHvN0ApQ5YCFAzRP0i6evwDqsoYujmKVmwtcwcUX02f7'
template "/opt/atlassian/bamboo/bamboo.cfg.xml" do
  source "bamboo.cfg.xml.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0644"
  variables(:bambooLicenseKey => #{bambooLicenseKey})
  notifies :restart, resources(:service => "bamboo")
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

link "/opt/atlassian/bamboo/plugins" do
  to "/mnt/bamboo_data/plugins"
  owner "bamboo"
  group "bamboo"
end

link "/opt/atlassian/bamboo/webapp/WEB-INF/lib/hung-build-killer-2.1.jar" do
  to "/mnt/bamboo_data/plugins/hung-build-killer-2.1.jar"
  owner "bamboo"
  group "bamboo"
end


