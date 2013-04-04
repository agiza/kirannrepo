#
# Cookbook Name:: infrastructure
# Definition:: authkey
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

define :authkey do
  
  directory "#{params[:user]}/.ssh" do
    recursive true
    action :create
  end

  begin
    authkeys = data_bag_item("infrastructure", "authkeys")
    rescue Net::HttpServerException
      raise ("Failed to load authkeys from infrastructure data bag.")
  end
  if authkeys.nil? || authkeys.empty?
    Chef::Log.info("Authkeys is empty or missing, unable to update keys file.")
  else
    template "/#{params[:user]}/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      owner "#{params[:user]}"
      group "#{params[:user]}"
      mode  "0600"
      variables(:authkeys => authkeys["#{params[:user]}"])
      action :create
    end
  end
end


