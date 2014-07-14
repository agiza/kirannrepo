#
# Cookbook Name:: docker-registry
# Recipe:: application_server
# Author:: Raul E Rangel (<Raul.E.Rangel@gmail.com>)
#
# Copyright 2014, Raul E Rangel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.default['docker-registry']['application_server'] = true

include_recipe "docker-registry"

%w[ /conf /conf/Catalina /conf/Catalina/localhost ].each do |path|
  directory path do
    owner "root"
    group "root"
    mode 00755
  end
end

template "/conf/Catalina/localhost/rd-correspondence.xml" do
  source "rd-correspondence.xml.erb"
  mode 00755
  owner "root"
  group "root"
end

template "/conf/Catalina/localhost/realdoc.xml" do
  source "realdoc.xml.erb"
  mode 00755
  owner "root"
  group "root"
end

template "/conf/Catalina/localhost/rd-proxy-image-generator.xml" do
  source "rd-proxy-image-generator.xml.erb"
  mode 00755
  owner "root"
  group "root"
end


template "/conf/rd-correspondence.properties" do
  source "rd-correspondence.properties.erb"
  mode 00755
  owner "root"
  group "root"
end
 
template "/conf/rd-proxy-image-generator.properties" do
  source "rd-proxy-image-generator.properties.erb"
  mode 00755
  owner "root"
  group "root"
end

template "/conf/realdoc.properties" do
  source "realdoc.properties.erb"
  mode 00755
  owner "root"
  group "root"
end

