#
# Cookbook Name:: rf-rm-tomcat
# Attributes:: rf-rm-tomcat
#
# Copyright 2012
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

# Environment attributes - value set in the environment
# used ub the ssl.conf.erb, shibboleth2.xml.erb, localLogout.html.erb, httpd.conf.erb
# default['rf_webproxy_host'] = ""
# used ub the ssl.conf.erb
# default['iam_app_host'] = ""
# used ub the ssl.conf.erb
# default['rm_app_host'] = ""


# Local attributes - used for all environments
default['rf_idp_metadata'] = "/etc/shibboleth/idp-metadata.xml"
default['rf_idp_metadatadir'] = "/etc/shibboleth"
default['rf_iam_sp_key'] = "/etc/shibboleth/sp-key.pem"
default['rf_iam_sp_cert'] = "/etc/shibboleth/sp-cert.pem"

