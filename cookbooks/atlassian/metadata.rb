maintainer       "Altisource"
maintainer_email "john.mcdonald@altisource.com"
license          "All rights reserved"
description      "Installs/Configures atlassian"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.4"
%w{infrastructure iptables altisource rvm}.each do |cookbook|
  depends cookbook
end
