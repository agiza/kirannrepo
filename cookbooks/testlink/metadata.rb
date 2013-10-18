name             'testlink'
maintainer       'Altisource Labs'
maintainer_email 'john.mcdonald@altisource.com'
license          'All rights reserved'
description      'Installs/Configures testlink'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# JSM: adding postfix cookbook dependency
depends "sendmail"
