#
# Cookbook Name:: github
# Recipe:: default
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

cloud_mount "storage" do
  device "/dev/xvdg"
  mountpoint "/storage"
  filesystem "ext4"
  options "defaults,nobootwait,comment=storage"
end

#cloud_mount "backup" do
#  device "/dev/xvdh"
#  mountpoint "/backup"
#  fstype "ext4"
#  options "defaults,nobootwait,comment=backup"
#end

cloud_mount "backups" do
  device "/dev/xvdi"
  mountpoint "/backups"
  filesystem "ext4"
  options "defaults,nobootwait,comment=backups"
end

%w{/home/ubuntu /home/ubuntu/.ssh}.each do |dir|
  directory "#{dir}" do
    owner "ubuntu"
    group "ubuntu"
  end
end

#template "/home/ubuntu/mount-storage.sh" do
#  source "mount-storage.sh.erb"
#  owner  "ubuntu"
#  group  "ubuntu"
#  mode   "0755"
#end

#execute "mountopt" do
#  command "/home/ubuntu/mount-storage.sh"
#  creates "/storage/lost+found"
#  action  :run
#end

file "/home/ubuntu/.ssh/authorized_keys" do
  owner "ubuntu"
  group "ubuntu"
  mode  "0600"
  content 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdBLEBMdX5GS4EHfVv5tWmPZNDS/bZqhOJzP1o1/FZaqwTcV4sz9zBrJnDVzcl61zuZQy/0Lq0zwudAPAEgKmbWmNNCyAaET+VU+39usA8tohmuo4u2CCi7y2djLHJIj2SxubkyLeBLXrs+pjN0l/gjJtssoRwTXKH06YD8UzWCGTu7YO5hc5cf54afpe8cWwxQCMK3Wh1I5bXCaeXt40br0hWg/WYIaEazenu8EGvrO+RdjPe27NlmV+Wlnug+a1HBgVa4FKx/MOqTJc8LTr0xDtpcmN587uUWaVZwriI47fvWkuPaKX4jMaqhAgauLMmSjvdugB29i6Mgz3RBCxR root
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmrk3cYSITTOLLAwT9VLd1fRp6uIYhRGdweevgLKRLgK6v31Qq+sRR3eluUaHoRXqTcBDC6gwHfBIhk0RgyCBp5oJM7oMNoqxm59Z0m6uoqdt0N76ZBDNhIOUPZ7Bo3XuSWutIdcGZF4AJ8SNk+KAmn6qO8YFplE66ztf2w2QcLpLECRbK1BXLwEcvNkdIx6Z0K5eyGiqmaMA8q3jyZsyw2Kv2/H8N037ZOERKGNW7XcrPq/3hUxdLWc0JjgNH7d1ZUOqoy/u+Q+H+j5W+AL/azLKTOLOCYCaSDbD9Vxj8G6OsrfM52WcKf4mmPgFvuQpter2GGJ3nhFwAqs30Q9jh admin
# gitolite start
command="/usr/share/gitolite/gl-auth-command id_rsa",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmrk3cYSITTOLLAwT9VLd1fRp6uIYhRGdweevgLKRLgK6v31Qq+sRR3eluUaHoRXqTcBDC6gwHfBIhk0RgyCBp5oJM7oMNoqxm59Z0m6uoqdt0N76ZBDNhIOUPZ7Bo3XuSWutIdcGZF4AJ8SNk+KAmn6qO8YFplE66ztf2w2QcLpLECRbK1BXLwEcvNkdIx6Z0K5eyGiqmaMA8q3jyZsyw2Kv2/H8N037ZOERKGNW7XcrPq/3hUxdLWc0JjgNH7d1ZUOqoy/u+Q+H+j5W+AL/azLKTOLOCYCaSDbD9Vxj8G6OsrfM52WcKf4mmPgFvuQpter2GGJ3nhFwAqs30Q9jh admin
# gitolite end'
  action :create
end

package "git" do
  action :upgrade
end

link "/var/lib/gitolite" do
  to "/storage/gitolite" 
end

group "gitolite" do
  gid 111
end

user "git" do
  comment"git repository hosting"
  uid 105
  gid 111
  home "/var/lib/gitolite"
  shell "/bin/bash"
end

user "gitolite" do
  comment"git repository hosting"
  uid 105
  gid 111
  home "/var/lib/gitolite"
  shell "/bin/bash"
end

%w{RDOC RF RTNG RecordRefs.pm}.each do |vref|
  template "/var/lib/gitolite/.gitolite/VREF/#{vref}" do
    source "#{vref}.erb"
      owner "gitolite"
      group "gitolite"
      mode  "0750"
   end
end

cron "backups" do
  minute "*/20"
  user "root"
  command "rsync -av --delete /storage/ /backups > /dev/null 2>&1"
end

