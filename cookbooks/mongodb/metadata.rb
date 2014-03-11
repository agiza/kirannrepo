maintainer       "Altisource"
maintainer_email "john.mcdonald@altisource.com"
license          "All rights reserved"
description      "Installs/Configures mongodb"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"
%w{altisource iptables monit}.each do |cb|
  depends cb
end
