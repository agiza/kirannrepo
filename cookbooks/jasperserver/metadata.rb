maintainer       "Altisource"
maintainer_email "kaviyarasan.ramalingam@altisource.com"
license          "All rights reserved"
description      "Installs/Configures altisource"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ infrastructure iptables }.each do |dep|
	depends dep
end






