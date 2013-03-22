#
# Cookbook Name:: altisource
# Definition:: volume_mount
#

define :volume_mount do
  
  template "/usr/local/bin/volgrp-mount.sh" do
    source "volgrp-create.erb"
    mode 0755
    group "root"
    owner "root"
    variables( :voldata => "#{params[:volumes]}" )
    notifies :run, "execute[volume-mount]", :immediately
  end
end

