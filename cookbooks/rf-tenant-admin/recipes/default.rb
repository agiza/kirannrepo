#
# Cookbook Name:: rf-tenant-admin
# Recipe:: default
#
# Copyright 2014, Altisource LABS
#
# All rights reserved - Do Not Redistribute
#
#
#
#

include_recipe 'apache2::default'

app_name = "rf-ta"
app_version = node[:"rf-ta_version"]
version_str = "rf-ta_version"

if node.attribute?('package_noinstall')
  Chef::Log.info("No version needed.")
else
  if app_version.nil? || app_version.empty? || app_version == "0.0.0-1"
    new_version = search(:node, "#{version_str}:* AND chef_environment:#{node.chef_environment}")
    if new_version.nil? || new_version.empty?
      Chef::Log.info("No version for #{app_name} software package found.")
    else
      version_string = []
      new_version.each do |version|
        version_string << version["#{version_str}"]
      end
      new_version = version_string.sort.uniq.last
      app_version = new_version
      node.set["#{version_str}"] = app_version
    end
  else
    Chef::Log.info("Found version attribute.")
  end
end

execute "yum-clean-all" do
  command 'yum clean all'
end


web_app 'tenant-admin' do
      server_name node['hostname']
      server_aliases [node['fqdn']]
      docroot "/opt/rf-ta/dist"
      cookbook 'apache2'
end

yum_package "#{app_name}" do
  version "#{app_version}"
  if node.attribute?('package_noinstall') || version == "0.0.0-1"
    Chef::Log.info("Package is set to not be installed for version is still invalid default.")
    action :nothing
  else
    action :install
  end
  flush_cache [ :before ]
  allow_downgrade true
end

#execute "import_jasper_reports.sh" do
#  command '/opt/RRPT/RTNG/reports/import_jasper_reports.sh'
#  only_if 'rpm -q rrpt-rtng-reports' 
#end

