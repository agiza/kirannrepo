#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "ubuntu","debian"
   package "ntpdate" do 
     action :upgrade
   end
end
   

package 'ntp' do 
   action :upgrade
end

service node[:ntp][:service] do
  service_name node[:ntp][:service]
  action [:enable, :start,:restart]
end


template "/etc/ntp.conf" do 
   source  "ntp.conf.erb"
   group 'root'
   owner 'root'
   mode  '0644'
   notifies :restart, resources(:service => node[:ntp][:service])
end
