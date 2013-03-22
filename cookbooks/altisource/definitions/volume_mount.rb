#
# Cookbook Name:: altisource
# Definition:: volume_mount
#

define :volume_mount do

  execute "volume-mount" do
    command "/usr/local/bin/#{params[:name]}"
    action :nothing
  end
  
  template "/usr/local/bin/#{params[:name]}.sh" do
    source "#{params[:name]}.erb"
    mode 0755
    group "root"
    owner "root"
    variables( :voldata => "#{params[:volumes]}" )
    notifies :run, "execute[volume-mount]", :immediately
  end
end

