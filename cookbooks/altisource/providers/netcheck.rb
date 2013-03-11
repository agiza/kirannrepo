action :prep do
  execute "prep" do
    only_if "which nc | grep 'which: no nc in'"
    command "yum install -y nc"
  end
end
begin
  action :check do
    execute "check" do
      command "nc -zw2 -v #{new_resource.name} #{new_resource.port}"
    end
  end
  raise "Network check for #{new_resource.name} on port #{new_resource.port} failed.  Either the network is not up, or the service is not responding."
end
