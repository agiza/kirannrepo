name             'rf-websrv'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures rf-websrv'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'


depends 'java'
depends 'shibboleth-sp'
depends 'tomcat-all'
depends 'apache2'
