name             'rf-iam-mysql'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures rf-iam-mysql'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

depends 'mysql-multi'
depends 'mysql'
#depends 'haproxy'
#depends 'rsyslog'