#
# Cookbook Name:: rabbitmq
# Resource:: exchange
#
# Copyright 2011-2013, Opscode, Inc.
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

actions :add, :delete, :set_binding, :set_binding_option, :clear_binding

attribute :exchange, :kind_of => String, :name_attribute => true
attribute :admin_user, :kind_of => String 
attribute :admin_password, :kind_of => String
attribute :vhost, :kind_of => String
attribute :source, :kind_of => String
attribute :type, :kind_of => String
attribute :destination, :kind_of => String
attribute :routingkey, :kind_of => String
attribute :option_key, :kind_of => String
attribute :option_value, :kind_of => String

def initialize(*args)
  super
  @action = :add
end
