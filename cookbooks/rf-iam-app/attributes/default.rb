#
# Cookbook Name:: shibboleth-idp
# Attributes:: shibboleth-idp
#
# Copyright 2012-2013 Nathan Mische, Brian Flad
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#include_attribute "tomcat"

default['shibboleth-idp']['container_auth'] = "form"
default['shibboleth-idp']['custom_webapp_templates'] = "asdf"
default['shibboleth-idp']['group'] = node['tomcat']['group']
default['shibboleth-idp']['idp_home'] = "/opt/shibboleth-idp"
default['shibboleth-idp']['host_name'] = node['rf_webproxy_host']
default['shibboleth-idp']['keystore_password'] = "changeit"
default['shibboleth-idp']['owner'] = node['tomcat']['user']
default['shibboleth-idp']['soap_port'] = 8443
default['shibboleth-idp']['status_allowed_ips'] = %w{ 127.0.0.1/32 ::1/128 }
default['shibboleth-idp']['template_cookbook'] = "shibboleth-idp"
default['shibboleth-idp']['tomcat6_dta_ssl_download_url'] = "https://build.shibboleth.net/nexus/content/repositories/releases/edu/internet2/middleware/security/tomcat6/tomcat6-dta-ssl/1.0.0/tomcat6-dta-ssl-1.0.0.jar"
default['shibboleth-idp']['version'] = "2.4.0"

# iptables
#default['shibboleth-idp']['ip_tables']['in_interface'] = ""

# Logging
default['shibboleth-idp']['logging']['edu.internet2.middleware.shibboleth'] = "INFO"
default['shibboleth-idp']['logging']['edu.vt.middleware.ldap'] = "WARN"
default['shibboleth-idp']['logging']['org.apache.catalina'] = "ERROR"
default['shibboleth-idp']['logging']['org.opensaml'] = "WARN"
default['shibboleth-idp']['logging']['org.springframework'] = "OFF"
default['shibboleth-idp']['logging']['PROTOCOL_MESSAGE'] = "OFF"

default['rf_idp_metadatafile'] = "/opt/shibboleth-idp/metadata/idp-metadata.xml"
default['rf_idp_servername'] = ""
default['rf_webproxy_host'] = ""
default['rf_sp_metadatafile'] = "/opt/shibboleth-idp/metadata/sp-metadata.xml"
default['tomcat']['home'] = "/opt/tomcat"
