#
# Cookbook Name:: infrastructure
# Recipe:: lamp
#
# Copyright 2013, Altisource
#
# All rights reserved - Do Not Redistribute
#
app_name = "updates"
#
# JSM: update/upgrade all packages on centos/rhel systems
 execute "yum-update-y" do
   command "yum clean all; yum update -y --disablerepo=altisourcecommon --disablerepo=altisourcerelease --disablerepo=altisourcetesting"
   ignore_failure true
   action :run
 end
 execute "yum-upgrade-y" do
   command "yum upgrade -y"
   ignore_failure true
   action :run
 end
