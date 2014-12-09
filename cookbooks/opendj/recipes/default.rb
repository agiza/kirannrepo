include_recipe 'java::default'

# Make sure we have what we need to unpack archives
package "unzip" do
  action :install
end

directory "#{node['opendj']['install_dir']}" do
  mode "0755"
end

cookbook_file "#{node['opendj']['installer_archive']}" do
  mode "0644"
end

user "#{node['opendj']['user']}" do
  comment "OpenDJ user"
  system true
end

script "unpack_archive" do
  interpreter "bash"
  cwd "#{node['opendj']['install_dir']}"
  code <<-EOH
  unzip #{node['opendj']['installer_archive']}
  chown -R #{node['opendj']['user']} #{node['opendj']['home']}
  chmod -R a+r #{node['opendj']['home']}
  find #{node['opendj']['home']} -type d -print0 | xargs -0 chmod a+x
  EOH
  not_if "test -d #{node['opendj']['home']}"
end

opendj_postinstallconfig "default" do
  action :nothing
  subscribes :run, resources("script[unpack_archive]"), :immediately
end

if node['opendj']['sync_enabled']
  group "#{node['opendj']['sync_group']}" do
    system true
  end
  user "#{node['opendj']['sync_user']}" do
    comment "OpenDJ sync user"
    gid "#{node['opendj']['sync_group']}"
    system true
  end
  directory "#{node['opendj']['sync_dir']}" do
    owner "#{node['opendj']['sync_user']}"
    mode "0755"
  end
  directory "#{node['opendj']['sync_dir']}/.ssh" do
    owner "#{node['opendj']['sync_user']}"
    mode "0755"
  end
  template "#{node['opendj']['sync_dir']}/.ssh/authorized_keys" do
    owner "#{node['opendj']['sync_user']}"
    mode "0644"
  end
  template "/etc/cron.daily/ldapsync.sh" do
    mode "0755"
  end
end
