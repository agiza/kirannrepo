#ntp Server Details
#
default['ntp_server'] = '0.rhel.pool.ntp.org'

case platform
when "redhat","centos","fedora","scientific"
  default[:ntp][:service] = "ntpd"
when "ubuntu","debian"
  default[:ntp][:service] = "ntp"
else
  default[:ntp][:service] = "ntpd"
end
