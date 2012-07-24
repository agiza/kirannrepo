#wq
# Cookbook Name:: realtrans-diff
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

directory "/home/ubuntu/work" do
  owner "ubuntu"
  group "ubuntu"
end

directory "/home/ubuntu/config" do
  owner "ubuntu"
  group "ubuntu"
end

directory "/home/ubuntu/bin" do
  owner "ubuntu"
  group "ubuntu"
end

directory "/home/ubuntu/.ssh" do
  owner "ubuntu"
  group "ubuntu"
end

directory "/opt/tomcat/.ssh" do
  owner "tomcat"
  group "tomcat"
end

directory "/mnt/tomcat/logs" do
  owner "tomcat"
  group "tomcat"
end

template "/home/ubuntu/bin/diff_properties.sh" do
  source "diff_properties.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

execute "diff" do
  command "/home/ubuntu/bin/diff_properties.sh"
  action :nothing
end

template "/etc/sudoers.d/90-tomcat" do
  source "90-tomcat.erb"
  owner "root"
  group "root"
  mode  "0440"
end

template "/home/ubuntu/config/realtrans-central.config" do
  source "realtrans-central.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-rp.config" do
  source "realtrans-rp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-fp.config" do
  source "realtrans-fp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-vp.config" do
  source "realtrans-vp.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-reg.config" do
  source "realtrans-reg.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-corelogic.config" do
  source "int-corelogic.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-datavision.config" do
  source "int-datavision.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-etrac.config" do
  source "int-etrac.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-interthinx.config" do
  source "int-interthinx.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-rs.config" do
  source "int-rs.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-rres.config" do
  source "int-rres.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realservicing.simulator.config" do
  source "realservicing.simulator.properties.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-central.xml" do
  source "realtrans-central.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-rp.xml" do
  source "realtrans-rp.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-fp.xml" do
  source "realtrans-fp.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-vp.xml" do
  source "realtrans-vp.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/realtrans-reg.xml" do
  source "realtrans-reg.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/config/int-rs.xml" do
  source "int-rs.xml.erb"
  owner  "tomcat"
  group  "tomcat"
  mode   "0644"
  notifies :run, resources(:execute => "diff")
end

template "/home/ubuntu/tomcat-clean.sh" do
  source "tomcat-clean.sh.erb"
  owner  "ubuntu"
  group  "ubuntu"
  mode   "0755"
end

file "/home/ubuntu/.ssh/authorized_keys" do
  owner "ubuntu"
  group "ubuntu"
  mode  "0600"
  content 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdBLEBMdX5GS4EHfVv5tWmPZNDS/bZqhOJzP1o1/FZaqwTcV4sz9zBrJnDVzcl61zuZQy/0Lq0zwudAPAEgKmbWmNNCyAaET+VU+39usA8tohmuo4u2CCi7y2djLHJIj2SxubkyLeBLXrs+pjN0l/gjJtssoRwTXKH06YD8UzWCGTu7YO5hc5cf54afpe8cWwxQCMK3Wh1I5bXCaeXt40br0hWg/WYIaEazenu8EGvrO+RdjPe27NlmV+Wlnug+a1HBgVa4FKx/MOqTJc8LTr0xDtpcmN587uUWaVZwriI47fvWkuPaKX4jMaqhAgauLMmSjvdugB29i6Mgz3RBCxR root
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAawcSfhnxjQfSoagGESb1wJtxaQuWDPXsqlnpArdck7nOb8P/DiAjA3wxdu4B5Fu7KIga6216essrEv6dRJeWEUCQxgowfX5PcEKA6dxbnnV28iZf9bF75vbSwtTpaGaKXoplvonA8UDG399Wa7Nyo8Hcf3bwRzggUdvozCAjWqOXyXwFrbx7yk0lG67UBODZihl8PRRPEP302Rr62KhIwipqaADv+DlA4Wkv7VmnvHi6L2Sly4VtftgW9w4JeuEX5IrIjOZPVYyBtgFNSGdgY4qv7mPyFkilltEO1Me/b5kmwwhn5CtMmHN0HtJnRZA/X5MCcwmLcVmdgFpkW8YX 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkcdrGS4/amnRMtMjmxlSXLkN7Mtu5OPf8aGpkTcpzQhi4aPzNe0e+qVsRxoqhxESrgIu5S1ZJ3ELHvdeYZ7u9wP/bWAPI0afS1PtaPUGTEEGu6y7e0DzxXzM7L9UDG56Nz/icXj+mylHH3Z/lGvkvfBq0wlDxUSSv0LoN26fVIWAFus/S0RwmpQzP7+DmpS3tDMNbjfNIi3ilXSIpXUJikxlbZU8shymEY5iqaW8Hs21/G10bTHuHpVjTgOuSY229e9dXM4RplAwkrJ07p0eOOLpQq6GnSiZAbZTsiXYnkaGTv7DZ7q9eMbU1ZZFcr05B8BSaKTuhsahcdJHIDbVF 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmrk3cYSITTOLLAwT9VLd1fRp6uIYhRGdweevgLKRLgK6v31Qq+sRR3eluUaHoRXqTcBDC6gwHfBIhk0RgyCBp5oJM7oMNoqxm59Z0m6uoqdt0N76ZBDNhIOUPZ7Bo3XuSWutIdcGZF4AJ8SNk+KAmn6qO8YFplE66ztf2w2QcLpLECRbK1BXLwEcvNkdIx6Z0K5eyGiqmaMA8q3jyZsyw2Kv2/H8N037ZOERKGNW7XcrPq/3hUxdLWc0JjgNH7d1ZUOqoy/u+Q+H+j5W+AL/azLKTOLOCYCaSDbD9Vxj8G6OsrfM52WcKf4mmPgFvuQpter2GGJ3nhFwAqs30Q9jh 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdBLEBMdX5GS4EHfVv5tWmPZNDS/bZqhOJzP1o1/FZaqwTcV4sz9zBrJnDVzcl61zuZQy/0Lq0zwudAPAEgKmbWmNNCyAaET+VU+39usA8tohmuo4u2CCi7y2djLHJIj2SxubkyLeBLXrs+pjN0l/gjJtssoRwTXKH06YD8UzWCGTu7YO5hc5cf54afpe8cWwxQCMK3Wh1I5bXCaeXt40br0hWg/WYIaEazenu8EGvrO+RdjPe27NlmV+Wlnug+a1HBgVa4FKx/MOqTJc8LTr0xDtpcmN587uUWaVZwriI47fvWkuPaKX4jMaqhAgauLMmSjvdugB29i6Mgz3RBCxR'
  action :create
end

file "/opt/tomcat/.ssh/authorized_keys" do
  owner  "tomcat"
  group  "tomcat"
  mode   "0600"
  content 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdBLEBMdX5GS4EHfVv5tWmPZNDS/bZqhOJzP1o1/FZaqwTcV4sz9zBrJnDVzcl61zuZQy/0Lq0zwudAPAEgKmbWmNNCyAaET+VU+39usA8tohmuo4u2CCi7y2djLHJIj2SxubkyLeBLXrs+pjN0l/gjJtssoRwTXKH06YD8UzWCGTu7YO5hc5cf54afpe8cWwxQCMK3Wh1I5bXCaeXt40br0hWg/WYIaEazenu8EGvrO+RdjPe27NlmV+Wlnug+a1HBgVa4FKx/MOqTJc8LTr0xDtpcmN587uUWaVZwriI47fvWkuPaKX4jMaqhAgauLMmSjvdugB29i6Mgz3RBCxR root
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAawcSfhnxjQfSoagGESb1wJtxaQuWDPXsqlnpArdck7nOb8P/DiAjA3wxdu4B5Fu7KIga6216essrEv6dRJeWEUCQxgowfX5PcEKA6dxbnnV28iZf9bF75vbSwtTpaGaKXoplvonA8UDG399Wa7Nyo8Hcf3bwRzggUdvozCAjWqOXyXwFrbx7yk0lG67UBODZihl8PRRPEP302Rr62KhIwipqaADv+DlA4Wkv7VmnvHi6L2Sly4VtftgW9w4JeuEX5IrIjOZPVYyBtgFNSGdgY4qv7mPyFkilltEO1Me/b5kmwwhn5CtMmHN0HtJnRZA/X5MCcwmLcVmdgFpkW8YX 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkcdrGS4/amnRMtMjmxlSXLkN7Mtu5OPf8aGpkTcpzQhi4aPzNe0e+qVsRxoqhxESrgIu5S1ZJ3ELHvdeYZ7u9wP/bWAPI0afS1PtaPUGTEEGu6y7e0DzxXzM7L9UDG56Nz/icXj+mylHH3Z/lGvkvfBq0wlDxUSSv0LoN26fVIWAFus/S0RwmpQzP7+DmpS3tDMNbjfNIi3ilXSIpXUJikxlbZU8shymEY5iqaW8Hs21/G10bTHuHpVjTgOuSY229e9dXM4RplAwkrJ07p0eOOLpQq6GnSiZAbZTsiXYnkaGTv7DZ7q9eMbU1ZZFcr05B8BSaKTuhsahcdJHIDbVF 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmrk3cYSITTOLLAwT9VLd1fRp6uIYhRGdweevgLKRLgK6v31Qq+sRR3eluUaHoRXqTcBDC6gwHfBIhk0RgyCBp5oJM7oMNoqxm59Z0m6uoqdt0N76ZBDNhIOUPZ7Bo3XuSWutIdcGZF4AJ8SNk+KAmn6qO8YFplE66ztf2w2QcLpLECRbK1BXLwEcvNkdIx6Z0K5eyGiqmaMA8q3jyZsyw2Kv2/H8N037ZOERKGNW7XcrPq/3hUxdLWc0JjgNH7d1ZUOqoy/u+Q+H+j5W+AL/azLKTOLOCYCaSDbD9Vxj8G6OsrfM52WcKf4mmPgFvuQpter2GGJ3nhFwAqs30Q9jh 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdBLEBMdX5GS4EHfVv5tWmPZNDS/bZqhOJzP1o1/FZaqwTcV4sz9zBrJnDVzcl61zuZQy/0Lq0zwudAPAEgKmbWmNNCyAaET+VU+39usA8tohmuo4u2CCi7y2djLHJIj2SxubkyLeBLXrs+pjN0l/gjJtssoRwTXKH06YD8UzWCGTu7YO5hc5cf54afpe8cWwxQCMK3Wh1I5bXCaeXt40br0hWg/WYIaEazenu8EGvrO+RdjPe27NlmV+Wlnug+a1HBgVa4FKx/MOqTJc8LTr0xDtpcmN587uUWaVZwriI47fvWkuPaKX4jMaqhAgauLMmSjvdugB29i6Mgz3RBCxR'
  action :create
end

