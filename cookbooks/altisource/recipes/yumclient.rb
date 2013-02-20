#
# Cookbook Name:: altisource
# Recipe:: yumclient
#

if search(:infrastructure, "id:proxy").nil? || search(:infrastructure, "id:proxy").empty?
  Chef::Log.info("No Proxies detected for yum in search.")
else
  proxyinfo = data_bag_item("infrastructure","proxy")
end
proxyserver = {}
search(:node, 'run_list:recipe\[infrastructure\:\:cntlmd\]') do |n|
  proxyserver[n.ipaddress] = {}
end
proxyserver = proxyserver.first
if proxyinfo.nil? || proxyinfo.empty? || proxyserver.nil? || proxyserver.empty? 
  Chef::Log.info("No Proxies detected for yum in search.")
else
  template "/etc/yum.conf" do
    source "yum.conf.erb"
    mode "0644"
    owner "root"
    group "root"
    variables(
      :proxyinfo => proxyinfo,
      :proxyserver => "#{proxyserver}:3128"
    )
  end
end
