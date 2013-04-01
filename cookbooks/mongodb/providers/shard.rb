#
# Cookbook Name:: mongodb
# Provider:: shard
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

def shard_exists?(replicaset)
  cmdStr = "mongo localhost:27017 --quiet --eval \"printjson(sh.status())\" | grep #{replicaset} | grep host"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "shard_exists?: #{cmdStr}"
  Chef::Log.debug "shard_exists?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :add do
  unless shard_exists?(new_resource.replicaset)
    cmdStr = "mongo localhost:27017 --quiet /data/db/shardadd.js"
    execute cmdStr do
      Chef::Log.debug "Shard added: #{cmdStr}"
      Chef::Log.info "Adding Shard for '#{new_resource.replicaset}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :enable do
  unless shard_exists?(new_resource.database)
    cmdStr = "mongo localhost:27017 --quiet db.runCommand( { enableSharding : \'#{new_resource.database}\" } )"
    execute cmdStr do
      Chef::Log.debug "shard_enabled: #{cmdStr}"
      Chef::Log.info "Enabling Sharding for '#{new_resource.database}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

