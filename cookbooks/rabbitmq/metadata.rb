maintainer       "Altisource"
maintainer_email "john.mcdonald@altisource.com"
license          "All rights reserved"
description      "Installs/Configures rabbitmq"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"
%w{infrastructure altisource iptables}.each do |cb|
  depends cb
end
