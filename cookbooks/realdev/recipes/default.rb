#
# Cookbook Name:: realdev
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

template "/root/mount-opt.sh" do
  source "mount-opt.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

execute "mountopt" do
  command "/root/mount-opt.sh"
  creates "/opt/lost+found"
  action  :run
end

service "altitomcat" do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

template "/root/tomcat-clean.sh" do
  source "tomcat-clean.sh.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

file "/root/.ssh/authorized_keys" do
  owner "root"
  group "root"
  mode  "0600"
  content 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdBLEBMdX5GS4EHfVv5tWmPZNDS/bZqhOJzP1o1/FZaqwTcV4sz9zBrJnDVzcl61zuZQy/0Lq0zwudAPAEgKmbWmNNCyAaET+VU+39usA8tohmuo4u2CCi7y2djLHJIj2SxubkyLeBLXrs+pjN0l/gjJtssoRwTXKH06YD8UzWCGTu7YO5hc5cf54afpe8cWwxQCMK3Wh1I5bXCaeXt40br0hWg/WYIaEazenu8EGvrO+RdjPe27NlmV+Wlnug+a1HBgVa4FKx/MOqTJc8LTr0xDtpcmN587uUWaVZwriI47fvWkuPaKX4jMaqhAgauLMmSjvdugB29i6Mgz3RBCxR root
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAawcSfhnxjQfSoagGESb1wJtxaQuWDPXsqlnpArdck7nOb8P/DiAjA3wxdu4B5Fu7KIga6216essrEv6dRJeWEUCQxgowfX5PcEKA6dxbnnV28iZf9bF75vbSwtTpaGaKXoplvonA8UDG399Wa7Nyo8Hcf3bwRzggUdvozCAjWqOXyXwFrbx7yk0lG67UBODZihl8PRRPEP302Rr62KhIwipqaADv+DlA4Wkv7VmnvHi6L2Sly4VtftgW9w4JeuEX5IrIjOZPVYyBtgFNSGdgY4qv7mPyFkilltEO1Me/b5kmwwhn5CtMmHN0HtJnRZA/X5MCcwmLcVmdgFpkW8YX
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkcdrGS4/amnRMtMjmxlSXLkN7Mtu5OPf8aGpkTcpzQhi4aPzNe0e+qVsRxoqhxESrgIu5S1ZJ3ELHvdeYZ7u9wP/bWAPI0afS1PtaPUGTEEGu6y7e0DzxXzM7L9UDG56Nz/icXj+mylHH3Z/lGvkvfBq0wlDxUSSv0LoN26fVIWAFus/S0RwmpQzP7+DmpS3tDMNbjfNIi3ilXSIpXUJikxlbZU8shymEY5iqaW8Hs21/G10bTHuHpVjTgOuSY229e9dXM4RplAwkrJ07p0eOOLpQq6GnSiZAbZTsiXYnkaGTv7DZ7q9eMbU1ZZFcr05B8BSaKTuhsahcdJHIDbVF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmrk3cYSITTOLLAwT9VLd1fRp6uIYhRGdweevgLKRLgK6v31Qq+sRR3eluUaHoRXqTcBDC6gwHfBIhk0RgyCBp5oJM7oMNoqxm59Z0m6uoqdt0N76ZBDNhIOUPZ7Bo3XuSWutIdcGZF4AJ8SNk+KAmn6qO8YFplE66ztf2w2QcLpLECRbK1BXLwEcvNkdIx6Z0K5eyGiqmaMA8q3jyZsyw2Kv2/H8N037ZOERKGNW7XcrPq/3hUxdLWc0JjgNH7d1ZUOqoy/u+Q+H+j5W+AL/azLKTOLOCYCaSDbD9Vxj8G6OsrfM52WcKf4mmPgFvuQpter2GGJ3nhFwAqs30Q9jh'
  action :create
end

#template "/opt/tomcat/conf/context.xml" do
#  source "context.xml.erb"
#  owner  "tomcat"
#  group  "tomcat"
#  mode   "0644"
#  notifies :restart, resources(:service => "altitomcat")
#end


