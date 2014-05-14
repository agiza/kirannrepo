maintainer       "Altisource"
maintainer_email "john.mcdonald@altisource.com"
license          "All rights reserved"
description      "Installs/Configures realdoc"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.22"
%w{altisource mongodb iptables infrastructure}.each do |cb|
	depends cb
end
