include_recipe "iptables::default"
iptables_rule "libreoffice-iptables"

%w(libreoffice-headless libreoffice-writer libreoffice-calc libreoffice-draw).each do |pkg|
  yum_package pkg do
    action :install
    version "3.4.5.2-16.1.el6_3"
    allow_downgrade true
  end
end

(8100..8109).each do |port|
  template "/etc/init/libreoffice-#{port}.conf" do
    source "libreoffice.conf.erb"
    variables(
        :port => port
    )
  end
end

(8100..8109).each do |instance|
  service "libreoffice-#{instance}" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end



