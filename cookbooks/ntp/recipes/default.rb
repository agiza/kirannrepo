#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'ntp' do 
   action :upgrade
end

ntpserver = data_bag_item("infrastructure","ntp")

template "/etc/ntp.conf" do 
   source  "ntp.conf.erb"
   group 'root'
   owner 'root'
   mode  '0644'
   notifies :restart, "service[ntpd]"
   variables(
       :ntpserver => ntpserver,
   )
end

service 'ntpd' do
   action [:enable, :start]
end
