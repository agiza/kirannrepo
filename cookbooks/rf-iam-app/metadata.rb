name             'rf-iam-app'
maintainer       'Altisource Labs'
maintainer_email 'yi.chen@altisource.com'
license          'All rights reserved'
description      'Installs/Configures rf-iam-app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends  'java'
depends  'tomcat-all'
depends  'rf-shib-sp-metagen'
depends  'mysql_connector'

