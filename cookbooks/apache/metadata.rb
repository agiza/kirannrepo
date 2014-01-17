maintainer       "Altisource"
maintainer_email "bryan.phinney@altisource.com"
license          "All rights reserved"
description      "Installs/Configures apache"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.7"
%w{iptables altisource}.each do |cb|
  depends cb
end
