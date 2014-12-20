#
# Cookbook Name:: rf-shib-sp-metagen
# Recipe:: default
#

%w[ /iam
    /iam/share].each do |path|
  directory path do
    owner "root"
    group "root"
    mode  '0777'
    action :create
  end
end

mount "/iam/share" do
  device "#{node['nfs_directory']}"
  fstype "nfs"
  options "rw"
  action [:mount, :enable]
end

cookbook_file "/iam/share/#{node.chef_environment}/keygen.sh" do
  source "keygen.sh"
  mode  '0775'
  owner "root"
  group "root"
  action :create_if_missing
end

cookbook_file "/iam/share/#{node.chef_environment}/metagen.sh" do
  source "metagen.sh"
  owner "root"
  group "root"
  mode '0755'
  action :create_if_missing
end

execute "Generate key" do
  command "/iam/share/#{node.chef_environment}/keygen.sh  -f -u shibd -h #{node['sp_public_hostname']} -y 3 -e https://#{node['sp_public_hostname']} -o /iam/share/#{node.chef_environment}/#{node['sp_app_name']}"
  not_if do
    File.exists?("/iam/share/#{node.chef_environment}/#{node['sp_app_name']}-sp-metadata.xml")
  end
end

execute "Generate SP metadata" do
  command "/iam/share/#{node.chef_environment}/metagen.sh -2ALN -c /iam/share/#{node.chef_environment}/#{node['sp_app_name']}/sp-cert.pem -e https://#{node['sp_public_hostname']}/shibboleth -h #{node['sp_public_hostname']} > /iam/share/#{node.chef_environment}/#{node['sp_app_name']}-sp-metadata.xml"
  not_if do
    File.exists?("/iam/share/#{node.chef_environment}/#{node['sp_app_name']}-sp-metadata.xml")
  end
end

file "/iam/share/#{node.chef_environment}/#{node['sp_app_name']}-sp-metadata.xml" do
  owner "root"
  group "root"
  mode '0755'
  action :touch
end