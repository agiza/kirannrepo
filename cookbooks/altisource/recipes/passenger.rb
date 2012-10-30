# Recipe:: passenger
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

execute "passenger" do
  command "yum install http://passenger.stealthymonkeys.com/rhel/6/passenger-release.noarch.rpm"
  creates "/etc/yum.repos.d/passenger.repo"
  action :run
end

