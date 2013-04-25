#
# Cookbook Name:: altisource
# Definition:: network_test
#

define :network_test do
  
  target = "#{params[:name]}"
  port = "#{params[:port]}"
  execute "check" do
    command "nc -zw2 -v #{target} #{port}"
    ignore_failure true
    Chef::Log.info("Network test of #{target} on port #{port}")
  end
end

