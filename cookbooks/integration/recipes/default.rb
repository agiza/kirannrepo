#
# Cookbook Name:: integration
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

include_recipe "altisource::altitomcat"

%w{amqphost_search rdochost_search}.each do |search|
  "#{search}" do
  end
end

