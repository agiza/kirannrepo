#
# Cookbook Name:: infrastructure
# Definition:: authkey
#
# Copyright 2012, Altisource
#
# All rights reserved - Do Not Redistribute
#

define :authkey do
  if "#{params[:name]}" == "root"
    userdir = "/#{params[:name]}"
  else
    userdir = "/home/#{params[:name]}"
  end
  directory "#{userdir}/.ssh" do
    recursive true
    action :create
  end

  begin
    authkeys = data_bag_item("infrastructure", "authkeys")
    rescue Net::HttpServerException
      raise ("Failed to load authkeys from infrastructure data bag.")
  end
  if authkeys["#{params[:name]}"].nil? || authkeys["#{params[:name]}"].empty?
    Chef::Log.info("Authkeys is empty or missing, unable to update keys file.")
  else
    template "#{userdir}/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      owner "#{params[:name]}"
      group "#{params[:name]}"
      mode  "0600"
      variables(:authkeys => authkeys["#{params[:name]}"])
      action :create
    end
  end
end


