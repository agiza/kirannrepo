#
# Cookbook Name:: altisource
# Definition:: netvolume_mount
#

define :netvolume_mount do

  execute "netvolume-mount" do
    command "/usr/local/bin/#{params[:name]}.sh"
    action :nothing
  end
  
  template "/usr/local/bin/#{params[:name]}.sh" do
    source "#{params[:name]}.erb"
    mode 0755
    group "root"
    owner "root"
    variables( :voldata => "#{params[:volumes]}" )
    notifies :run, "execute[netvolume-mount]", :immediately
  end
end

