# JSM: added monit initially to do mongos restarts if process dies
#
# Include epel repository for optional packages
include_recipe "altisource::epel-local"
include_recipe "sendmail"

package "monit"

service "monit" do
  action [:enable, :start]
  enabled true
  supports [:start, :restart, :stop]
end

directory "/etc/monit/conf.d/" do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

directory "/var/monit/" do
  owner  'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

template "/etc/monit.conf" do
  owner "root"
  group "root"
  mode 0700
  source 'monit.conf.erb'
  notifies :restart, resources(:service => "monit"), :delayed
end
