#
# Cookbook Name:: rf-haproxy
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

#Search Service Proxy
haproxy_lb 'tomcat_searchservice_frontend' do
  params([
              'bind *:8080',
              'mode http',
              'timeout client 5000ms',
              'timeout server 5000ms',
              'default_backend tomcat_searchservice_backend',
              'option httpclose',
              'option httplog'
         ])
end

members_search = search("node", "chef_environment:#{node.chef_environment} AND rf_search_server:true") || []
servers_search = members_search.uniq.map do |s|
  "#{s[:hostname]} #{s[:ipaddress]}:8080 check"
end

haproxy_lb 'tomcat_searchservice_backend' do
  type 'backend'
  servers servers_search
  params([
             'balance roundrobin',
             'mode http'
         ])
end

#RabbitMQ Proxy
haproxy_lb 'rabbitmq_frontend' do
  params([
             'bind *:5672',
             'mode tcp',
             'default_backend rabbitmq_backend',
             'option tcplog'
         ])
end

members_rabbit = search("node", "chef_environment:#{node.chef_environment} AND rf-rabbitmq-cluster:*") || []
servers_rabbit = members_rabbit.uniq.map do |s|
  "#{s[:hostname]} #{s[:ipaddress]}:5672 maxconn 6000 check"
end

haproxy_lb 'rabbitmq_backend' do
  type 'backend'
  servers servers_rabbit
  params([
             'balance roundrobin',
             'mode tcp'
         ])
end

include_recipe "haproxy::default"

node.set['rf_proxy'] = true