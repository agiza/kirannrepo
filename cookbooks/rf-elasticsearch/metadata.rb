name             'rf-elasticsearch'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures rf-elasticsearch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.2'

depends "altisource"
depends "iptables"
depends "java-wrapper"
depends "elasticsearch", "~> 0.3.10"



