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
#default['rf_rm_rpm_version'] = "1.0.0-RC"

#default['rf_rm_basic_authentication_define'] = "-Dspring.profiles.active=dev"

#default['rf_webproxy_host'] = "rf-devint-iam-web1.altidev.net"

#default['rf_idp_servername'] = "rf-devint-iam-app1.altidev.net"

#mongo properties
default['rf_rm_mongo_database'] = "realservicing-runtime"
#default['rf_rm_mongo_replicaset'] = "rf-devint-rm-mongodb-srv1.altidev.net:27017"

#rabbit properties for Rules Management
#default['rf_indexing_host'] = "rf-devint-search-rabbit-srv1.altidev.net"

default['rf_indexing_host_port'] = "5672"
default['rf_indexing_host_username'] = "rulesmgmt"
default['rf_indexing_host_password'] = "rulesmgmt12"
default['rf_indexing_host_virtualHost'] = "RulesPublishing"


