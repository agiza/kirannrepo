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
 execute "rc-local-chef-client" do
   command "echo chef-client > /etc/rc.local"
   ignore_failure true
   action :run
 end
