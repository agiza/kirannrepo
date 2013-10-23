#
## Installs rpmforge repo into yum
#


if platform_family?("rhel")

    remote_file "#{Chef::Config[:file_cache_path]}/rpmforge-release-#{node[:infrastructure][:rpmforge][:version]}.#{node[:kernel][:machine]}.rpm" do
      source "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-#{node[:infrastructure][:rpmforge][:version]}.#{node[:kernel][:machine]}.rpm"
      action :create
    end

    yum_package "rpmforge-release" do
      source "#{Chef::Config[:file_cache_path]}/rpmforge-release-#{node[:infrastructure][:rpmforge][:version]}.#{node[:kernel][:machine]}.rpm"
      action :install
    end
    
    remote_file "#{node[:infrastructure][:rpmforge][:gpg_key]}" do
      source "http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt"
      notifies :run, "execute[import_rpmforge_key]", :immediately
    end
 
    execute "import_rpmforge_key" do
      user "root"
      command "rpm --import #{node[:infrastructure][:rpmforge][:gpg_key]} && yum --enablerepo=rpmforge update"
      action :nothing
    end
end
