#
# Cookbook Name:: JasperReports
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#
#
package 'rrpt-rtng-reports' do
   action :upgrade
end

execute "import_jasper_reports.sh" do
  command '/opt/RRPT/RTNG/reports/import_jasper_reports.sh'
  only_if 'rpm -q rrpt-rtng-reports' 
end

