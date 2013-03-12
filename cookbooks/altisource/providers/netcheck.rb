action :prep do
  execute "prep" do
    only_if "which nc | grep 'which: no nc in'"
    command "yum install -y nc"
  end
end
action :check do
  execute "check" do
    command "nc -zw2 -v #{new_resource.name} #{new_resource.port}"
    ignore_failure true
    Chef::Log.info("Result of network test of #{new_resource.name} on port #{new_resource.port}", return_code)
  end
end
