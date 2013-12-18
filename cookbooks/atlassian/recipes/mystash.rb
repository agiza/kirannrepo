#
## Cookbook Name:: atlassian
## Recipe:: mystash
##
## Copyright 2013, Altisource
##
## All rights reserved - Do Not Redistribute
##
#
#

bash 'test_mystash' do
  code <<-EOH
    cd /tmp
    echo "test" > /tmp/test_mystash.out
    EOH
  not_if { ::File.exists?(install_vers) }
end

