#
# Cookbook Name:: atlassian
# Recipe:: bamboo
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#
cloud_mount "opt" do
  device "/dev/xvdl"
  mountpoint "/opt"
  fstype "ext4"
  options "defaults"
end

cloud_mount "backups" do
  device "/dev/xvdo"
  mountpoint "/backups"
  filesystem "ext4"
  options "defaults"
end

cloud_mount "mnt" do
  device "/dev/xvdj"
  mountpoint "/mnt"
  fstype "ext4"
  options "defaults"
end

cloud_mount "bamboo_data" do
  device "/dev/xvdn"
  mountpoint "/mnt/bamboo_data"
  fstype "ext4"
  options "defaults"
end

service "bamboo" do
  supports :stop => true, :start => true, :restart => true, :status => true
  action :nothing
end

execute "bamboo-plugins" do
  command "/home/bamboo/bin/bamboo-plugins.sh"
  action :nothing
end

%w{/home/bamboo/.ssh /home/bamboo/bin}.each do |dir|
  directory "#{dir}" do
    owner "bamboo"
    group "bamboo"
    action :create
  end
end

template "/opt/atlassian/bamboo/bamboo.cfg.xml" do
  source "bamboo.cfg.xml.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0664"
  notifies :restart, resources(:service => "bamboo")
end

remote_file "/opt/atlassian/bamboo/webapp/WEB-INF/lib/mysql-connector-java-5.1.22-bin.jar" do
  source "http://10.0.0.20/yum/common/mysql-connector-java-5.1.22-bin.jar"
  mode  "0644"
  owner "bamboo"
  group "bamboo"
  action :create_if_missing
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

template "/etc/cron.daily/bamboo-rsyncs.sh" do
  source "bamboo-rsyncs.sh.erb"
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

# build the uber string form of app names
app_names = ''
node[:apps].each do |app|
  app_names << "#{app[:name]}|#{app[:version]}|#{app[:recipe]} "
end
# circumcise the uber string (trim the extra space from the end)
app_names = app_names[0..-2]

Chef::Log.warn("Using app_names = #{app_names}")

template "/home/bamboo/bin/rpm-package" do
  source "rpm-package.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
  variables( :application_names => app_names )
end

template '/home/bamboo/bin/package-realdoc-mongoup2date-scripts' do
  source 'package-realdoc-mongoup2date-scripts.sh.erb'
  owner 'bamboo'
  group 'bamboo'
  mode  '0755'
  variables(
      :yum => {
          :host => node[:yumrepo_host],
          :username => node[:yum_user]
      },
      :git => {
          :host => node[:git_repo],
          :username => 'git'
      }
  )
end

template '/home/bamboo/bin/package-mongoup2date' do
  source 'package-mongoup2date.sh.erb'
  owner 'bamboo'
  group 'bamboo'
  mode  '0755'
  variables(
      :yum => {
          :host => node[:yumrepo_host],
          :username => node[:yum_user]
      },
      :git => {
          :host => node[:git_repo],
          :username => 'git'
      }
  )
end

template "/home/bamboo/bin/bamboo-plugins.sh" do
  source "bamboo-plugin.sh.erb"
  owner  "bamboo"
  group  "bamboo"
  mode   "0755"
  notifies :run, 'execute[bamboo-plugins]', :immediately
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

link "/usr/lib/jdk1.7.0_147" do
  to "/opt/jdk1.7.0_147"
  owner "root"
  group "root"
end

link "/usr/lib/jvm/jdk1.6.0_25" do
  to "/usr/lib/jdk1.6.0_25"
  owner "root"
  group "root"
end

link "/usr/lib/jvm/jdk1.7.0_147" do
  to "/usr/lib/jdk1.7.0_147"
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

service "bamboo" do
  action [:enable, :start]
end

include_recipe 'infrastructure::rpmforge'
include_recipe 'rvm::system'
