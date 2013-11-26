maintainer       "Altisource"
maintainer_email "john.mcdonald@altisource.com"
license          "All rights reserved"
description      "Installs/Configures infrastructure"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.7"
%w{altisource iptables java}.each do |dep|
  depends dep
end 
