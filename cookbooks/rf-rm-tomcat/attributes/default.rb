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

# The commented attributes will be defined in the environment
# We will use those lines only the setup of local environments
# In that case one should uncomment the lines and use it

# default['rf']['rm']['shibboleth']['host'] = ""
# default['rf']['rm']['iam']['host'] = ""

#mongo properties
default['rf']['rm']['mongo']['database'] = "realservicing-runtime"
# default['rf']['rm']['mongo']['replicaset'] = ""

#rabbit properties for Rules Management
# default['rf']['rm']['rabbit']['host'] = ""
# default['rf']['rm']['rabbit']['port'] = "5672"
# default['rf']['rm']['rabbit']['username'] = "rulesmgmt"
# default['rf']['rm']['rabbit']['password'] = "rulesmgmt12"
# default['rf']['rm']['rabbit']['virtualHost'] = "RulesPublishing"


