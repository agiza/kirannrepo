#
# Cookbook Name:: mongodb
# Provider:: replicaset
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

def whyrun_supported
  true
end

def whyrun_mode?
  Chef::Config[:whyrun]
end

def replicaset_exists?(name)
  cmdStr = "mongo localhost:27017 --quiet --eval \"printjson(rs.status())\" | grep name | wc -l"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "Replicaset_check?: #{cmdStr}"
  if "#{cmd.stdout}" == 3
    Chef::Log.debug "Replicaset exists?: #{cmd.stdout}"
    return true
  else
    Chef::Log.debug "Replicaset does not exist?: #{cmd.stdout}"
    Chef::Log.debug "Replicaset does not exist?: #{cmd.exitstatus}"
    return false
  end
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :create do
  unless replicaset_exists?(new_resource.replicaset)
    cmdStr = "mongo localhost:27017 --quiet /etc/mongo/rsadd.js"
    execute cmdStr do
      Chef::Log.debug "replicaset_create: #{cmdStr}"
      Chef::Log.info "Adding Replicaset '#{new_resource.replicaset}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

