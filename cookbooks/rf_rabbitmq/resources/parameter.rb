#
# Cookbook Name:: rf-rabbitmq
# Resource:: parameter
#
# Author: Altisource
# Copyright 2014, Altisource
#

actions :set, :clear, :list
default_action :set

attribute :parameter, :kind_of => String, :name_attribute => true
attribute :component, :kind_of => String
attribute :options, :kind_of => Hash
attribute :vhost, :kind_of => String