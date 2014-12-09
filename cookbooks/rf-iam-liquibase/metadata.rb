name             'rf-iam-liquibase'
maintainer       'AltiSource Labs'
maintainer_email ''
license          'All rights reserved'
description      'Installs/Configures rf-iam-liquibase'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends "liquibase-cookbook-master"
depends "rf-iam-mysql"
depends 'mysql_connector'