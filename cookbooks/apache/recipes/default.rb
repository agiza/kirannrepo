#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

package "apache2" do
  case node[:platform]
  when "centos","redhat","fedora","suse"
    package_name "httpd"
  when "debian","ubuntu"
  package_name "apache2"
  end
  action :upgrade
end

package "mod_security" do
  case node[:platform]
  when "centos","redhat","fedora","suse"
    package_name "mod_security"
  when "debian","ubuntu"
    package_name "libapache2-modsecurity"
  end
  action :upgrade
end

service "apache2" do
  case node[:platform]
  when "centos","redhat","fedora","suse"
    service_name "httpd"
  when "debian","ubuntu"
    service_name "apache2"
  end
  supports :stop => true, :start => true, :restart => true, :reload => true
  action [:enable, :start]
end

case node[:platform]
  when "centos","redhat","fedora","suse"
    template "/etc/httpd/conf/httpd.conf" do
      source "httpd.rhel.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :reload, resources(:service => "httpd")
    end
  when "debian","ubuntu"
    template "/etc/apache2/httpd.conf" do
      source "httpd.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :reload, resources(:service => "apache2")
    end
end

case node[:platform]
  when "debian","ubuntu"
    directory "/etc/apache2/proxy-available" do
      owner "root"
      group "root"
    end

    directory "/etc/apache2/proxy-enabled" do
      owner "root"
      group "root"
    end

    template "/etc/apache2/ports.conf" do
      source "ports.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :reload, resources(:service => "apache2")
    end

    template "/etc/apache2/apache2.conf" do
      source "apache2.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :reload, resources(:service => "apache2")
    end

    template "/etc/apache2/conf.d/security" do
      source "security.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :reload, resources(:service => "apache2")
    end

    template "/etc/apache2/mods-available/000-default" do
      source "default.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :reload, resources(:service => "apache2")
    end

    template "/etc/apache2/mods-available/000-default-ssl" do
      source "default-ssl.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :reload, resources(:service => "apache2")
    end
   
    template "/etc/apache2/proxy-available/rtqaproxy.conf" do
      source "rtqaproxy.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(:servers => server_list)
      notifies :reload, resources(:service => "apache2")
    end

    template "/etc/apache2/proxy_available/rtdemoproxy.conf" do
      source "rtdemoproxy.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(:servers => server_list)
      notifies :reload, resources(:service => "apache2")
    end

    link "/etc/apache2/proxy-enabled/rtqaproxy.conf" do
      to "../proxy-available/rtqaproxy.conf"
      owner "root"
      group "root"
      only_if "test -f /etc/apache2/proxy-available/rtqaproxy.conf"
    end

    link "/etc/apache2/proxy-enabled/rtdemoproxy.conf" do
      to "../proxy-available/rtdemoproxy.conf"
      owner "root"
      group "root"
      only_if "test -f /etc/apache2/proxy-available/rtdemoproxy.conf"
    end
end

template "/etc/apache2/mods-available/corelogic-dev-mod_proxy" do
  source "corelogic-dev-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/corelogic-demo-mod_proxy" do
  source "corelogic-demo-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/corelogic-qa-mod_proxy" do
  source "corelogic-qa-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/datavision-dev-mod_proxy" do
  source "datavison-dev-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/datavision-demo-mod_proxy" do
  source "datavison-demo-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

template "/etc/apache2/mods-available/datavision-qa-mod_proxy" do
  source "datavison-qa-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

server_list = Hash.new
rt_servers = search(:node, "role:Realtrans-CORE AND chef_environment:QA").each do |server|
  server_list[server.hostname] = server.ipaddress
end

template "/etc/apache2/mods-available/vpn-mod_proxy" do
  source "vpn-mod_proxy.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "apache2")
end

link "/etc/apache2/mods-enabled/proxy_http.load" do
  to "../mods-available/proxy_http.load"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/proxy_http.load"
end

link "/etc/apache2/mods-enabled/proxy.conf" do
  to "../mods-available/proxy.conf"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/proxy.conf"
end

link "/etc/apache2/mods-enabled/proxy.load" do
  to "../mods-available/proxy.load"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/proxy.load"
end

link "/etc/apache2/mods-enabled/proxy_balancer.load" do
  to "../mods-available/proxy_balancer.load"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/proxy_balancer.load"
end

link "/etc/apache2/mods-enabled/proxy_balancer.conf" do
  to "../mods-available/proxy_balancer.conf"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/proxy_balancer.conf"
end

link "/etc/apache2/mods-enabled/auth_digest.load" do
  to "../mods-available/auth_digest.load"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/auth_digest.load"
end

link "/etc/apache2/mods-enabled/ssl.conf" do
  to "../mods-available/ssl.conf"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/ssl.conf"
end

link "/etc/apache2/mods-enabled/ssl.load" do
  to "../mods-available/ssl.load"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/ssl.load"
end

link "/etc/apache2/mods-enabled/mod-security.load" do
  to "../mods-available/mod-security.load"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/mod-security.load"
end

link "/etc/apache2/mods-enabled/mod-security.conf" do
  to "../mods-available/mod-security.conf"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/mod-security.conf"
end

link "/etc/apache2/mods-enabled/unique_id.load" do
  to "../mods-available/unique_id.load"
  owner "root"
  group "root"
  only_if "test -f /etc/apache2/mods-available/unique_id.load"
end

