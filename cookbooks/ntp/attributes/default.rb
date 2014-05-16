#ntp Server Details
#
case platform
when "redhat","centos","fedora","scientific"
   default['ntp_server'] = '0.rhel.pool.ntp.org'
when "ubuntu","debian"
   default['ntp_server'] = 'ntp.ubuntu.com'
else
   default['ntp_server'] = '0.rhel.pool.ntp.org'
end
   

case platform
when "redhat","centos","fedora","scientific"
  default[:ntp][:service] = "ntpd"
when "ubuntu","debian"
  default[:ntp][:service] = "ntp"
else
  default[:ntp][:service] = "ntpd"
end
