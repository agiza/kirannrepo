#
# Cookbook Name:: jetty
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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

default["tomcat"]["port"] = 8080
default["tomcat"]["ssl_port"] = 8443
default["tomcat"]["ajp_port"] = 8009
default["tomcat"]["java_options"] = "-javaagent:/opt/appdynamic-agent/javaagent.jar -Dappdynamics.viewer.host=appdynamix -Xrunjdwp:transport=dt_socket,address=5005,suspend=n,server=y -Xms512m -Xmx1024m -XX:MaxPermSize=512m -Djava.awt.headless=true"
default["tomcat"]["use_security_manager"] = false

case platform
when "centos","redhat","fedora"
  set["tomcat"]["user"] = "tomcat"
  set["tomcat"]["group"] = "tomcat"
  set["tomcat"]["home"] = "/opt/tomcat"
  set["tomcat"]["base"] = "/opt/tomcat"
  set["tomcat"]["config_dir"] = "/opt/tomcat/conf"
  set["tomcat"]["log_dir"] = "/opt/tomcat/logs"
  set["tomcat"]["tmp_dir"] = "/opt/tomcat/temp"
  set["tomcat"]["work_dir"] = "/opt/tomcat/work"
  set["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  set["tomcat"]["webapp_dir"] = "/opt/tomcat/webapps"
when "debian","ubuntu"
  set["tomcat"]["user"] = "tomcat"
  set["tomcat"]["group"] = "tomcat"
  set["tomcat"]["home"] = "/opt/tomcat"
  set["tomcat"]["base"] = "/opt/tomcat"
  set["tomcat"]["config_dir"] = "/opt/tomcat/conf"
  set["tomcat"]["log_dir"] = "/opt/tomcat/logs"
  set["tomcat"]["tmp_dir"] = "/opt/tomcat/temp"
  set["tomcat"]["work_dir"] = "/opt/tomcat/work"
  set["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  set["tomcat"]["webapp_dir"] = "/opt/tomcat/webapps"
else
  set["tomcat"]["user"] = "tomcat"
  set["tomcat"]["group"] = "tomcat"
  set["tomcat"]["home"] = "/opt/tomcat"
  set["tomcat"]["base"] = "/opt/tomcat"
  set["tomcat"]["config_dir"] = "/opt/tomcat/conf"
  set["tomcat"]["log_dir"] = "/opt/tomcat/logs"
  set["tomcat"]["tmp_dir"] = "/opt/tomcat/temp"
  set["tomcat"]["work_dir"] = "/opt/tomcat/work"
  set["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  set["tomcat"]["webapp_dir"] = "/opt/tomcat/webapps"
end
