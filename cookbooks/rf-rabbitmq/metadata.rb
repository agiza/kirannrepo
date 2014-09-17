name             'rf-rabbitmq'
maintainer       'Altisource Labs'
maintainer_email 'cosmin.vasii@endava.com'
license          'All rights reserved'
description      'Installs/Configures rf-rabbitmq'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.0'

depends 'rabbitmq-cluster', '~> 3.3.2'
depends 'iptables', '~> 0.14.0'
depends 'rf-hosts', '~> 0.1.0'
