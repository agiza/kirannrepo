maintainer       "Altisource"
maintainer_email "bryan.phinney@altisource.com"
license          "All rights reserved"
description      "Installs/Configures atlassian"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"
%w{infrastructure altisource}.each do |cookbook|
  depends cookbook
end
